Rails.configuration.stripe = {
    :publishable_key => Settings.stripe_public_key,
    :secret_key      => Settings.stripe_api_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]