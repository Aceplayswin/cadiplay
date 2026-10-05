from django.urls import path

from core import backoffice_views as views

urlpatterns = [
    path('admin/bo/payment-methods', views.payment_methods),
    path('admin/bo/payment-methods/create', views.payment_methods_create),
    path('admin/bo/payment-methods/<int:method_id>', views.payment_methods_update),
    path('admin/bo/payment-providers', views.payment_providers),
    path('admin/bo/payment-providers/create', views.payment_providers_create),
    path('admin/bo/payment-providers/<int:provider_id>', views.payment_providers_update),
    path('admin/bo/bin-rules', views.bin_rules),
    path('admin/bo/bin-rules/create', views.bin_rules_create),
    path('admin/bo/bin-rules/<int:rule_id>', views.bin_rules_update),
    path('admin/bo/frontend-rules', views.frontend_rules),
    path('admin/bo/frontend-rules/create', views.frontend_rules_create),
    path('admin/bo/frontend-rules/<int:rule_id>', views.frontend_rules_update),
    path('admin/bo/queues/<str:queue_type>', views.queue_items),
    path('admin/bo/queues/items/<int:item_id>', views.queue_item_update),
]
