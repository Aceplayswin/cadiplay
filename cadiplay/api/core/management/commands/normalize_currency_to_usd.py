"""Rewrite stored currency codes to USD.

The house ledger is USD. Clients display that unit as USDT. Older rows and
``platform_settings`` JSON still say INR (or USDT). This command flips those
codes to USD without touching amounts.

    python manage.py normalize_currency_to_usd --dry-run
    python manage.py normalize_currency_to_usd

Idempotent. Safe to run on every deploy.
"""

from django.core.management.base import BaseCommand
from django.db import connection

from core.models import PlatformSetting
from core.money import BACKEND_CURRENCY

# Tables that have a varchar currency (or currency_code) column.
CURRENCY_TABLES = (
    ('user_settings', 'currency'),
    ('wallets', 'currency'),
    ('transactions', 'currency'),
    ('game_sessions', 'currency'),
    ('game_rounds', 'currency'),
    ('game_providers', 'currency_code'),
    ('affiliates', 'currency'),
    ('affiliate_commission_ledger', 'currency'),
    ('affiliate_payouts', 'currency'),
    ('agents', 'currency'),
    ('cashier_queue_items', 'currency'),
)

LEGACY_CODES = ('INR', 'USDT')
SETTINGS_KEYS = ('affiliate_program', 'agent_program')


class Command(BaseCommand):
    help = 'Rewrite stored INR/USDT currency codes to USD (idempotent).'

    def add_arguments(self, parser):
        parser.add_argument(
            '--dry-run',
            action='store_true',
            help='Print how many rows would change without writing anything.',
        )

    def handle(self, *args, **options):
        dry_run = options['dry_run']
        total = 0
        with connection.cursor() as cursor:
            present = _tables(cursor)
            for table, column in CURRENCY_TABLES:
                if table not in present:
                    continue
                if column not in _columns(cursor, table):
                    continue
                cursor.execute(
                    f'SELECT COUNT(*) FROM `{table}` '
                    f'WHERE `{column}` IN ({_placeholders(LEGACY_CODES)})',
                    LEGACY_CODES,
                )
                count = cursor.fetchone()[0]
                if not count:
                    continue
                total += count
                self.stdout.write(f'{table}.{column}: {count} row(s)')
                if not dry_run:
                    cursor.execute(
                        f'UPDATE `{table}` SET `{column}` = %s '
                        f'WHERE `{column}` IN ({_placeholders(LEGACY_CODES)})',
                        [BACKEND_CURRENCY, *LEGACY_CODES],
                    )
                    try:
                        cursor.execute(
                            f"ALTER TABLE `{table}` ALTER `{column}` "
                            f"SET DEFAULT '{BACKEND_CURRENCY}'"
                        )
                    except Exception:
                        pass

        settings_changed = _normalize_settings(dry_run)
        total += settings_changed
        if settings_changed:
            self.stdout.write(f'platform_settings currency: {settings_changed} row(s)')

        if dry_run:
            self.stdout.write(self.style.WARNING(
                f'Dry run: {total} change(s) would be written.'
            ))
            return
        if total:
            self.stdout.write(self.style.SUCCESS(
                f'Rewrote {total} currency value(s) to {BACKEND_CURRENCY}.'
            ))
        else:
            self.stdout.write(self.style.SUCCESS(
                f'Every currency column is already {BACKEND_CURRENCY}.'
            ))


def _tables(cursor) -> set[str]:
    cursor.execute(
        'SELECT table_name FROM information_schema.tables '
        'WHERE table_schema = DATABASE()'
    )
    return {row[0] for row in cursor.fetchall()}


def _columns(cursor, table: str) -> set[str]:
    cursor.execute(
        'SELECT column_name FROM information_schema.columns '
        'WHERE table_schema = DATABASE() AND table_name = %s',
        [table],
    )
    return {row[0] for row in cursor.fetchall()}


def _placeholders(values) -> str:
    return ', '.join(['%s'] * len(values))


def _normalize_settings(dry_run: bool) -> int:
    changed = 0
    for key in SETTINGS_KEYS:
        row = PlatformSetting.objects.filter(setting_key=key).first()
        if not row or not isinstance(row.setting_value, dict):
            continue
        current = row.setting_value.get('currency')
        if current in LEGACY_CODES or current is None:
            changed += 1
            if not dry_run:
                value = dict(row.setting_value)
                value['currency'] = BACKEND_CURRENCY
                row.setting_value = value
                row.save(update_fields=['setting_value'])
    return changed
