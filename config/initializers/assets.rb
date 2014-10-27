# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css.sass, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( statics.css statics.js zoomico.png blog.css swipebox.css blue.css.scss animate.min.css )
