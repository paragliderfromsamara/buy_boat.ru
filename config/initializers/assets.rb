# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( shop.scss ) 
Rails.application.config.assets.precompile += %w( shop.coffee )

Rails.application.config.assets.precompile += %w( salut.scss ) 
Rails.application.config.assets.precompile += %w( salut.coffee )

Rails.application.config.assets.precompile += %w( realcraft.scss ) 
Rails.application.config.assets.precompile += %w( realcraft.coffee ) 

Rails.application.config.assets.precompile += %w( control.scss ) 
Rails.application.config.assets.precompile += %w( control.coffee ) 