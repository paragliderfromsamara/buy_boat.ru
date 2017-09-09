module RealcraftHelper
  def make_photos_interchange(url, size = "small")
    "[#{url.gsub(size, "small")}, small], [#{url.gsub(size, "medium")}, medium], [#{url.gsub(size, "large")}, large], [#{url.gsub(size, "xlarge")}, xlarge]"
  end
  
  
  def wrapper_bg_image(img) #добавляет адрес к папке с изображениями фона блока
    %{/realcraft_files/content_blocks_images/#{img}}
  end
  def main_page_slider_imgs #изображения слайдера с главной страницы
    [
      "/realcraft_files/slider/rc200/4_slider_small.jpg",
      "/realcraft_files/slider/index/1_small.jpg",
      "/realcraft_files/slider/index/4_small.jpg"
    ]
  end
  
  def make_photos_links(photos, boat_folder)
    url = "/realcraft_files#{boat_folder}/photos/"
    photos.map {|p| {xlarge: "#{url}#{p}_xlarge.jpg", large: "#{url}#{p}_large.jpg", medium: "#{url}#{p}_medium.jpg", small: "#{url}#{p}_small.jpg", thumbnail: "#{url}#{p}_thumbnail.jpg"}}
  end
  
  def rc_header(big, small = nil, small_bot = nil)
    v = ""
    v += "<h3>#{small.mb_chars.upcase}</h3>" if !small.nil? 
    v += "<h1>#{big.mb_chars.upcase}</h1>"
    v += "<h4>#{small_bot.mb_chars.upcase}</h4>" if !small_bot.nil? 
    return "<div id = \"rc-header\">#{v}</div>".html_safe
  end
  
  def model_view_imgs_name
    [
      {url: "top_model_view.jpg", title: t(:top_view)},
      {url: "back_model_view.jpg", title: t(:aft_view)},
      {url: "forward_model_view.jpg", title: t(:bow_view)}
    ]
  end
  
  def rcParamsHash(title, unit, value, notice="")
    {title: title, unit: unit, value: value, notice: notice}
  end
  
  def searchRCParamValByTitle(title)
    return 0 if @boat.nil?
    return 0 if @boat[:boat_parameters].blank?
    @boat[:boat_parameters].each {|p| return p if p[:title] == title}
    return 0 
  end
  
  def hash_boats_list
    [real_craft_190, real_craft_200]
  end
  
  def boats_for_request_form
    vals = []
    b_list = @boat.nil? ? hash_boats_list : [@boat]
    b_list.each do |b|
      if b[:modifications].blank?
        vals.push(b[:name])
      else
        b[:modifications].each do |m|
          vals.push([%{#{b[:name]} #{m[:name]}}, %{#{b[:name]} #{m[:name]}}])
        end
      end
    end
    return vals
  end
    
  def real_craft_190
    boat_folder = "/boat_pages/rc190"
    @ru_head_desc = "Лодка RealCraft 190 предоставляет владельцу широкие возможности для всех видов отдыха на воде. Увеличенный основной кокпит, широкий проход в носовой кокпит, ровный пол, под которым большие отсеки для хранения якорей, фалов, кранцев и других вещей, предназначенные для спиннингов и удилищ полочки вдоль бортов делают RealCraft 190 отличной лодкой для увлеченного рыболова."
    @en_head_desc = "Realсraft 190 can provide you a wide range of leisure
activities on the water. Increased main cockpit, wide
passage to the front cockpit, level floor, spacious units 
for storage of anchors, halyards, fenders and other
things, shelves for spinning and fishing rods along the 
boards make Realсraft 190 a great boat for enthusiastic 
fishermen."
    @ru_slogan = "СОЗДАНА ДЛЯ ТЕХ, 
                  КТО НЕ БОИТСЯ САМЫХ 
                  ЭКСТРЕМАЛЬНЫХ МЕТЕО
                   УСЛОВИЙ"
    @en_slogan = "DESIGNED FOR PEOPLE WHO
                ARE USED TO NAVIGATING
                  IN THE MOST EXTREME 
                    CONDITIONS"
    v = {
      url: realcraft_190_path,
      name: "REALCRAFT 190",
      modifications_present_text_en: "Realcraft 190 boats can be delivered in several versions of equipment packages of bow cockpit and main cockpit seats",
      modifications_present_text_ru: "Лодки Realcraft 190 могут поставляться в двух модификациях носового кокпита и кресел основного кокпита.",
      slider_images: [
                        "/realcraft_files/slider/rc190/1_small.jpg",
                        "/realcraft_files/slider/rc190/2_small.jpg",
                        "/realcraft_files/slider/rc190/3_small.jpg"
                     ],
      design_category: "C",
      slogan_ru: @ru_slogan, 
      slogan_en: @en_slogan, 
      header_description_ru: @ru_head_desc, 
      header_description_en: @en_head_desc,
      index_page_parameters: [14, 4, 5],
      main_params_big: [0,4,5],
      main_params_small: [1,2,3,14,9,10],
      boat_parameters: [
                          rcParamsHash(t(:crew_limit), t(:pers_short), 5),                     #0
                          rcParamsHash(t(:max_permitted_load), t(:kg_short), 500),             #1
                          rcParamsHash(t(:hull_thickness), t(:mm_short), 4),                   #2
                          rcParamsHash(t(:freeboard_thickness), t(:mm_short), 2),              #3
                          rcParamsHash(t(:length_of_hull), t(:m_short), 5.1),                  #4
                          rcParamsHash(t(:beam_of_hull), t(:m_short), 1.76),                   #5
                          rcParamsHash(t(:max_length), t(:m_short), 5.1),                      #6
                          rcParamsHash(t(:max_beam), t(:m_short), 1.76),                       #7
                          rcParamsHash(t(:transom_beam), t(:m_short), 1.66),                   #8
                          rcParamsHash(t(:bot_deadrise_angle), "˚", 11),                       #9
                          rcParamsHash(t(:empty_craft_mass), t(:kg_short), [347, 389]),        #10
                          rcParamsHash(t(:light_craft_mass), t(:kg_short), [554, 596], t(:light_craft_mass_desc)),        #11
                          rcParamsHash(t(:maximum_load_craft_mass), t(:kg_short), [1054, 1096], t(:maximum_load_craft_mass_desc)),  #12
                          rcParamsHash(t(:weight_on_trailer), t(:kg_short), [573, 615]),          #13
                          rcParamsHash(t(:max_eng_power), t(:hp_short), (cur_locale == :en ? 50 : 70)),                      #14
                          rcParamsHash(t(:max_eng_mass), t(:kg_short), 162),                      #15
                          rcParamsHash(t(:length_of_st_cable), t(:ft_short), 14),                 #16
                          rcParamsHash(t(:length_of_rc_cable), t(:ft_short), 12),                 #17
                       ], 
      photos: make_photos_links([1,2,3,4], boat_folder),
      videos: [
        "<iframe width=\"1280\" height=\"720\" src=\"https://www.youtube.com/embed/fxN92HTzx4U\" frameborder=\"0\" allowfullscreen></iframe>"
      ],
      modifications: [
                        {
                          name: "BD Comfort",
                          model_view_imgs: model_view_imgs_name.map {|i| {url: "/realcraft_files/boat_pages/rc190/comfort/#{i[:url]}", title: i[:title]}},
                          acc_views_imgs: ["/realcraft_files/boat_pages/rc190/comfort/acc_1.jpg", "/realcraft_files/boat_pages/rc190/comfort/acc_2.jpg"],
                          description_en: "BD means \"BowDeck\" - with bow cockpit closed with removable cover-deck. It modification has three fore lockers and fixed aft locker, which fold out making a comfortable sleeping accommodation.",
                          description_ru: "BD расшифровывается как \"BowDeck\" - с закрытым носовым кокпитом со съёмным люком. Эта модификация снабжена тремя носовыми рундуками и одним кормовым, который раскладываясь образует комфортное спальное место."
                        },
                        {
                          name: "BR Light",
                          model_view_imgs: model_view_imgs_name.map {|i| {url: "/realcraft_files/boat_pages/rc190/light/#{i[:url]}", title: i[:title]}},
                          acc_views_imgs: ["/realcraft_files/boat_pages/rc190/light/acc_1.jpg", "/realcraft_files/boat_pages/rc190/light/acc_2.jpg"],
                          description_en: "BR means \"BowRider\" - With open bow cockpit. It modification has fore swivel seats on support and fixed aft locker.",
                          description_ru: "BR расшифровывается как \"BowRider\" - с открытым носовым кокпитом. Данная модификация снабжена удобными передними поворотными сиденьями и кормовым рундуком."
                        },
                     ],
     engeneering_text_en: "Strong hull with a 4-mm bottom of 5083 Al-Mg sheet together with a perfect seagoing performance that is justified by carefully estimated body lines with 11° dead rise angle at the transom provide smooth sailing from first open waters to the late fall. Do not fear storms, stony shores, drowned logs and even floating ice floes. Moreover, the boat is quite cost effective: Realcraft 190 can raise the maximum speed of over 50 kmph due to a 40 powered motor. If the boat carries five people, it shall plane on the water surface of more than 40 kmph. In case you mount an engine of power capability of 50 horsepower these indicators will be much better.",
     engeneering_text_ru: "RealCraft 190 предназначен людей, эксплуатирующих свои лодки в самых суровых условиях. Прочный корпус с днищем из 4-миллиметрового листа АМг5М и хорошая мореходность, обусловленная тщательно просчитанными обводами с килеватостью на транце 11 градусов, обеспечивают беспроблемное плавание с открытия навигации до поздней осени. Не опасаясь штормов, каменистых берегов, подтопленных бревен и даже плавающих льдин. При этом лодка лостаточно экономична: с  40-сильным мотором RealCraft 190 способен развивать максимальную скорость около 50 км/час, с экипажем из пяти человек лодка будет глиссировать на скорости выше 40 км/час. Если подвесить двигатель допустимой мощностью 50 л.с., то эти показатели будут гораздо лучше.",
     engeneering_img: "/boat_pages/rc190/schema.png"
                     
    }
  end
  
  
  
  def real_craft_200
    boat_folder = "/boat_pages/rc200"
    @ru_head_desc = "Новейший RealCraft 200 –лодка с задним расположением консолей. 
    Такая компоновка с большим носовым кокпитом актуальна для различных служб, проводящих спасательные и патрульные операции на воде. 
    А также для дайвинга, рыбалки, буксировки лыжников, перевозки габаритных грузов на расположенную на островах дачу и просто прогулок с хорошей компанией друзей.
    Носовой кокпит по периметру опоясан релингами, что повышает безопасность пассажиров на ходу, а рыбаки закрепляют на них стаканы для спиннингов. В носу находится рундук-сиденье, помогающий при выходе на берег и предназначенный для хранения якоря и швартовых. По бортам перед консолями расположены два рундука, а вдоль бортов протянулись полки, куда можно положить удилища. Между бортовыми рундуками под герметичной крышкой форпика закреплен стандартный переносной бензобак – такое расположение не только улучшает центровку, но и соответствует европейским требованиям ISO по разнесению горючего и аккумуляторов на расстояние. Под кормовым диваном большой отсек с аккумулятором и главным выключателем.
                        "
    @en_head_desc = "The newest Realcraft 200 is a boat with a rear location
of consoles. Such arrangement together with big fore cockpit is vital for various rescue and patrol operations as well as diving, fishing, towing skiers, transportation
of large loads to the summer house on the islands or just cruises with a good company of friends."
    @ru_slogan = "Для заядлых рыбаков, патруля, спасательных операций ну и конечно для приключений в компании друзей.".mb_chars.upcase
    @en_slogan = "FOR TRUE FISHERMEN, RESCUE AND PATROL OPERATIONS OR JUST CRUISES WITH A GOOD COMPANY OF FRIENDS"
    v = {
      url: realcraft_200_path,
      name: "REALCRAFT 200",
      modifications_present_text_en: "Realcraft 190 boats can be delivered in several versions of equipment packages of bow cockpit and main cockpit seats",
      modifications_present_text_ru: "Лодки Realcraft 190 могут поставляться в двух модификациях носового кокпита и кресел основного кокпита.",
      slider_images: [
                        "/realcraft_files/slider/rc200/4_slider_small.jpg",
                        "/realcraft_files/slider/rc200/1_slider_small.jpg",
                        "/realcraft_files/slider/rc200/2_slider_small.jpg",
                        "/realcraft_files/slider/rc200/3_slider_small.jpg",
                     ],
      design_category: "C",
      slogan_ru: @ru_slogan, 
      slogan_en: @en_slogan, 
      header_description_ru: @ru_head_desc, 
      header_description_en: @en_head_desc, 
      index_page_parameters: [14, 4, 5],
      main_params_big: [0,4,5],
      main_params_small: [1,2,3,14,9,10],
      boat_parameters: [
        rcParamsHash(t(:crew_limit), t(:pers_short), 5),                     #0
        rcParamsHash(t(:max_permitted_load), t(:kg_short), 500),             #1
        rcParamsHash(t(:freeboard_thickness), t(:mm_short), 2),              #2
        rcParamsHash(t(:hull_thickness), t(:mm_short), 4),                   #3
        rcParamsHash(t(:length_of_hull), t(:m_short), 5.1),                  #4
        rcParamsHash(t(:beam_of_hull), t(:m_short), 1.9),                    #5
        rcParamsHash(t(:max_length), t(:m_short), 5.1),                      #6
        rcParamsHash(t(:max_beam), t(:m_short), 1.9),                        #7
        rcParamsHash(t(:transom_beam), t(:m_short), 1.72),                   #8
        rcParamsHash(t(:bot_deadrise_angle), "˚", 13),                       #9
        rcParamsHash(t(:empty_craft_mass), t(:kg_short), [378, 390]),        #10
        rcParamsHash(t(:light_craft_mass), t(:kg_short), [585, 597], t(:light_craft_mass_desc)),        #11
        rcParamsHash(t(:maximum_load_craft_mass), t(:kg_short), [1085, 1097], t(:maximum_load_craft_mass_desc)),  #12
        rcParamsHash(t(:weight_on_trailer), t(:kg_short), [604, 616]),          #13
        rcParamsHash(t(:max_eng_power), t(:hp_short), (cur_locale == :en ? 50 : 70)),                      #14
        rcParamsHash(t(:max_eng_mass), t(:kg_short), 162),                      #15
        rcParamsHash(t(:length_of_st_cable), t(:ft_short), 11),                 #16
        rcParamsHash(t(:length_of_rc_cable), t(:ft_short), 9)                   #17
                       ], 
      photos: make_photos_links([1,2,3,4], boat_folder),
      videos: [
        "<iframe width=\"496\" height=\"279\" src=\"https://www.youtube.com/embed/J0JQXQbo01M\" frameborder=\"0\" allowfullscreen></iframe>"
      ],
      modifications: [
                        {
                          name: "Pro",
                          model_view_imgs: model_view_imgs_name.map {|i| {url: "/realcraft_files//boat_pages/rc200/pro/#{i[:url]}", title: i[:title]}},
                          acc_views_imgs: ["/realcraft_files//boat_pages/rc200/acc_1.jpg", "/realcraft_files//boat_pages/rc200/acc_2.jpg"],
                          description_en: "PRO Version goes with the direct plastic or tempered glass",
                          description_ru: "Версия \"Pro\" выпускается с прямым ветровым остеклением. Остекление может быть выполнено как из пластика, так и калёного стекла"
                        },
                        {
                          name: "Navi",
                          model_view_imgs: model_view_imgs_name.map {|i| {url: "/realcraft_files//boat_pages/rc200/navi/#{i[:url]}", title: i[:title]}},
                          acc_views_imgs: ["/realcraft_files//boat_pages/rc200/acc_1.jpg", "/realcraft_files//boat_pages/rc200/acc_2.jpg"],
                          description_en: "Navi version with the curved plastic glass",
                          description_ru: "Модификация \"Navi\" выпускается с гнутым ветровым остеклением выполненным из оргстекла."
                        },
                     ],
     engeneering_text_en: "The fore cockpit along the perimeter is belted with railings which increase the safety of passengers, while fishermen may use it for fastening of spinnings. There is a locker-seat in the fore, intended for storage of the anchor and mooring equipment, which will be useful for landfalls. There are two lockers, located along the broadside in front of the consoles, as
well as shelves where you can put fishing rods. You can find a standard portable petrol tank between the broadside lockers under the lid of the floor:
this location increases the alignment as well as corresponds with ISO European Requirements
on a distance spacing of petrol and accumulators. There is also a big section with the accumulator and the main switcher under the sternmost couch.",
     engeneering_text_ru: "Корпус RealCraft 200 с тщательно рассчитанными обводами имеет угол килеватости 13 градусов на транце, который плавно увеличивается к носу лодки. Две пары реданов проходят не до кормы, а обрываются именно там, где нужно – это результат точной инженерной работы для повышения гидродинамических качеств. Результатом явилась безупречная мореходность и маневренность, а также достойные скоростные качества. С 50-сильным двухтактным мотором и двумя членами экипажа выход на глиссирование занимает 5 секунд, а дифферент при этом не превышает 14º. При максимальной скорости 58 км/час лодка идет на ровном киле!",
     engeneering_img: "/boat_pages/rc200/schema.png"
    }
  end
  
  def slider_imgs(imgs) #imgs - это массив содерщий ссылки на фотографии small
    return "" if imgs.blank?
    v = ""
    j=0
    imgs.each do |i|
      next if i.index("small").nil?
      t = "data-interchange=\"[#{i}, small], [#{i.gsub("small", "medium")}, medium], [#{i.gsub("small", "large")}, large], [#{i.gsub("small", "xlarge")}, xlarge]\""
      v += "
            <div class = \"#{"is-active " if j==0}orbit-slide rc-slide\" style = \"background-image: url('#{i}');\" #{t}>
            </div>
           "
      j+= 1
    end
    return v
  end
  
  def production_photos(ph_name, preview_size = "small")
    path_name = "/realcraft_files/production_photos"
    return {url: "#{path_name}/#{ph_name}_#{preview_size}.jpg", list: "[#{path_name}/#{ph_name}_small.jpg, small], [#{path_name}/#{ph_name}_medium.jpg, medium], [#{path_name}/#{ph_name}_large.jpg, large], [#{path_name}/#{ph_name}_xlarge.jpg, xlarge]"}
  end
  
  def dealers_page_content
    [
        {
          wrapper_bg_image: "boat_test_top_1_small.jpg",
          fog_class: "hard-fog white-bg",
          row_class: "tb-pad-l",
          columns: [
                      {
                        #2-й и 3-й абзацы
                        col_class: "small-6",
                        ru_content: %{Сертификацию проводила одна из крупнейших и уважаемых в Европе финская фирма VTT.<br /><br /> CE-сертификаты получены нами только недавно, нашим лодкам открыт путь для поставок в Европу. Мы ищем дилеров для продвижения и продажи лодок в Европе.},
                        en_content: %{Certification was conducted by one of the largest and most respected Finnish company VTT. <br /><br /> CE-certificates have been received only recently and our boats have opened the way for deliveries to Europe. We are looking for dealers to promote and sell boats in Europe.}
                      },
                      {
                        col_class: "small-6",
                        content: link_to(image_tag("/realcraft_files/files/vtt_logo.png", class: "float-center").html_safe, "http://www.vttexpertservices.com/", target: "_blank")
                      }
                   ]
        },
        {
          row_class: "tb-pad-m",
          columns: [
                        {
                          #4-й абзац
                          col_class: "small-6",
                          ru_content: %{Мы предлагаем выгодные условия поставки, гарантируем высокое качество катеров, соблюдение договорных положений о поставках и гарантии.},
                          en_content: %{We offer favorable terms of delivery and prices, guarantee high quality of boats, compliance with contractual terms for supplies and guarantees.}
                        },
                        {
                          #5-й абзац
                          col_class: "small-6",
                          ru_content: %{Предлагаемые нами условия позволят приобрести в Европе лодку высокого качества по самой привлекательной цене с учетом  интереса дилера.},
                          en_content: %{Our offer will allow to purchase a high quality boat in Europe at the most attractive price, taking into account the dealer's interest.}
                        }
                   ] 
        },
        {
          wrapper_class: "blue-block",
          row_class: "tb-pad-m",
          columns: [
                       {
                         #6-й абзац
                          col_class: "small-12 text-center medium-font", 
                          ru_content: %{Для первых – пробных поставок предусмотрены специальные условия.},
                          en_content: %{For the first - trial delivery special conditions are provided.}
                        }
                   ] 
        },
        {
          wrapper_class: "blue-bg",
          wrapper_bg_image: "boat_1_small.jpg",
          fog_class: "hard-fog dark-blue-bg",
          row_class: "tb-pad-l",
          columns: [
                       {
                         #7-й абзац
                         col_class: "small-12 text-center medium-font",
                         ru_content: %{Если Вы хотите стать нашим дилером, напишите нам на почту #{mail_to "info@realcraftboats.com"}, или заполните заявку <a data-form-in-dealers>здесь</a> и мы вышлем вам необходимую информацию.},
                         en_content: %{If you want to become our dealer, write us #{mail_to "info@realcraftboats.com"} or fill request form <a data-form-in-dealers>here</a> and we'll send you the necessary information.}
                        }
                   ] 
        }
    ]
  end
  
  def prices_page_content
    [
        {
          #wrapper_bg_image: "boat_2_small.jpg",
          #fog_class: "hard-fog dark-blue-bg",
          row_class: "tb-pad-m medium-font",
          columns: [
                      {
                        #3-й абзац
                        col_class: "small-12 text-center medium-font",
                        ru_content: %{Поскольку только недавно мы получили CE-сертификаты, мы пока еще не имеем дилеров в ЕС.},
                        en_content: %{Because we received CE -certificates only recently, we have no dealers in EU yet.}
                      }
                   ]
        },
        {
          wrapper_bg_image: "boat_2_small.jpg",
          fog_class: "hard-fog dark-blue-bg",
          row_class: "tb-pad-m medium-font white-font",
          columns: [
                      {
                        #3-й абзац
                        col_class: "small-12 medium-5 text-center",
                        ru_content: %{Поскольку такая покупка может показаться хлопотной,  до тех пор, пока в вашей стране  не появится удобный для Вас дилер, мы предлагаем особые цены для наших покупателей из Европы.},
                        en_content: %{Since such a purchase may seem troublesome, until we have no dealer convenient for you in our country, we offer special prices for our customers from Europe.}
                      },
                      {
                        #4-й абзац
                        col_class: "small-12 medium-6 medium-offset-1 text-center",
                        ru_content: %{Мы можем доставить лодку непосредственно на ваше место, но, к сожалению, это достаточно дорого.  Поэтому мы предлагаем передать вам лодку в Российской Федерации около таможенного пункта пропуска на удобной для вас границе с Евросоюзом.},
                        en_content: %{We can deliver the boat directly to your place, but, unfortunately, it is quite expensive. Therefore, we propose to give you a boat in the Russian Federation near the customs checkpoint at a convenient border with the European Union.}
                      }
                   ]
        },
        {
          #wrapper_bg_image: "boat_3_small.jpg",
          #fog_class: "hard-fog white-bg",
          wrapper_class: "blue-bg",
          row_class: "tb-pad-m large-font",
          columns: [
                      {
                        col_class: "small-12 medium-10 medium-centered text-center",
                        ru_content: %{от <span class = "stat">7000</span> ЕВРО за лодку},
                        en_content: %{from about <span class = "stat">7000</span> EUR for a high quality boat...}
                      }
                   ]
        },
        {
          wrapper_bg_image: "boat_3_small.jpg",
          fog_class: "hard-fog white-bg",
          row_class: "tb-pad-m large-font",
          columns: [
                      {
                        #5-й абзац
                        col_class: "small-12 medium-10 medium-centered text-center",
                        ru_content: %{С учетом  предлагаемых скидок к нашим ценам в России вы получаете возможность приобрести катер по уникальной цене – от  7000 ЕВРО за лодку высокого качества с длиной корпуса 5,1 метра, несравнимо меньшей, чем цена других предлагаемых в Европе лодок соответствующей категории.},
                        en_content: %{Taking into account the offered discounts to our prices in Russia, you get the opportunity to purchase a boat at a unique price, incomparably less than the price of other boats of the corresponding category offered in Europe - from about 7000 EUR for a high quality boat with a hull length of 5.1 meters.}
                      }
                   ]
        },
        {
          #wrapper_bg_image: "boat_3_small.jpg",
          #fog_class: "hard-fog white-bg",
          wrapper_class: "dark-blue-bg",
          row_class: "tb-pad-s large-font",
          columns: [
                      {
                        #5-й абзац
                        col_class: "small-12 medium-10 medium-centered text-center",
                        ru_content: %{Если Вы хотите приобрести лодку, напишите нам на почту #{mail_to "info@realcraftboats.com"}, <br /> или заполните заявку <a data-form-in-price>здесь</a>},
                        en_content: %{If you want to purchase a boat, write us #{mail_to "info@realcraftboats.com"} <br /> or fill a boat request form <a data-form-in-price>here</a>}
                      }
                   ]
        },
        {
          #wrapper_bg_image: "boat_3_small.jpg",
          #fog_class: "hard-fog white-bg",
          wrapper_class: "dark-blue-bg",
          row_class: "tb-pad-s medium-font",
          columns: [
                      {
                        #5-й абзац
                        col_class: "small-12 medium-7 medium-centered text-center",
                        ru_content: %{Мы гарантируем высокое качество катеров, соблюдение договорных положений о поставках и гарантии.},
                        en_content: %{We guarantee the high quality of boats, compliance with contractual provisions for supplies and guarantees.}
                      }
                   ]
        }
    ]
  end
end
