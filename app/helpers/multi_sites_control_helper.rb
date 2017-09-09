module MultiSitesControlHelper
  def all_sites
    [ # %w( domain_name in_app_name )
                        %w( control control ),
                        %w( realcraftboats realcraft ),
                        %w( salut-boats salut ),
                        %w( myapps shop )
     ]
  end
  

  
  def domain_url(part_name)
    domains = request.host.split('.')
    part_domain = ""
    all_sites.each do |s|
      if s[1] == part_name
        part_domain = s[0]
        break
      end
    end
    if part_name == "control"
      url = "#{part_name}.#{domains[domains.length-2]}.#{domains[domains.length-1]}"
    else
      url = "#{part_name}.#{domains[domains.length-1]}"
    end
    url += ":#{request.port}" if request.port >= 3000
    return "http://#{url}" 
  end
  
  def is_realcraft?
    current_site == "realcraft"
  end
  
  def is_salut? 
    current_site == "salut"
  end
  
  def is_control?
    current_site == "control"
  end
  
  def is_shop? 
    current_site == "shop"
  end
  
  def get_site_name #определяет какой домен вызывается
    domains = request.host.split('.')
    all_sites.each do |s|
      return s[1] if !domains.index(s[0]).nil?
    end
    return all_sites.last[1] #по умолчанию сайт определяется как shop
  end
  
  def current_site=(site_name) #выдает внутреннее название сайта по которому пришел запрос, которые необходимо отрисовывать
    @current_site = site_name
  end
  
  def current_site
    @current_site ||= get_site_name
  end
  
  def cur_locale #текущая локаль
    I18n.locale
  end
  
  def opposite_locale_url #создает ссылку на противоположную локаль
    v = cur_locale == :ru ? [".ru", ".com"] : [".com", ".ru"]
    return request.url.gsub(v[0], v[1])
  end
  
end
