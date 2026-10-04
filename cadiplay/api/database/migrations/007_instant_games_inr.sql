-- Instant Games (Aviator / Spribe crash) are an INR line. Players created on
-- that line cannot be relaunched in USD (aggregator error 10011).
UPDATE game_providers SET currency_code = 'INR' WHERE slug = 'instant';
