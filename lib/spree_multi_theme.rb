module SpreeOdgTheme
  class Engine < Rails::Engine
    APP_THEME = YAML.load_file("config/settings.yml")
    %x{for m in "`ls ../spree_odg_theme/themes`"; do echo "options: \\"$m\\"" > ../spree_odg_theme/config/themes.yml ; done}
    railtie_name "spree_odg_theme"
    @current_theme = APP_THEME['theme']
    @current_theme = 'theme1' if  @current_theme.empty?

    config.autoload_paths += %W(#{config.root}/lib)
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../themes/#{@current_theme}/app/overrides/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end      
    end
    
    paths["app/assets"] << "themes/#{@current_theme}/app/assets"
    paths["app/views"] << "themes/#{@current_theme}/app/views"
    paths["vendor/assets"] << "themes/#{@current_theme}/vendor/assets"
    config.to_prepare &method(:activate).to_proc
  end
end