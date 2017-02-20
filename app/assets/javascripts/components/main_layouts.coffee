@initSessionForm = ->
    winParams = {
                winId: "#reveal_form_window"
                loadEl: "#session_form"
                url: "/signin?nolayout=true"
                winHeader: "Вход на сайт"
                }
    getRemoteForm(winParams)

@initRegistrationForm = ->
    winParams = {
                winId: "#reveal_form_window"
                loadEl: "#user_form"
                url: "/signup?nolayout=true"
                winHeader: "Регистрация на сайте"
                }
    getRemoteForm(winParams)


whiteMenuLeft = {_class: "menu", li_list: [{text: "КупитьЛодку.рф", href: "/", className: "logo-field"}]}
whiteMenuRight = {_class: "menu float-right", li_list: [
                                            {text: "ВЫБОР ЛОДКИ", href: "/boat_types"},
                                            {text: "ЛОДКИ В НАЛИЧИИ", href: "/boat_types"},
                                            {text: "СПЕЦПРЕДЛОЖЕНИЯ", href: "/boat_types"}
                                           ]
                 }
darkUnsignedMenu = {
                      _class: "menu float-right", li_list: [{text: "ВХОД", urlClickHandle: @initSessionForm}, {text: "РЕГИСТРАЦИЯ", urlClickHandle: @initRegistrationForm}] 
                   }

darkSignedMenu = {
                      _class: "menu float-right", li_list: [{text: "ЛИЧНЫЙ КАБИНЕТ", href: "/cabinet"}, {text: "ВЫХОД", urlRemote: true, href: "/signout"}] 
                  }
    
@MainMenu = React.createClass
    getInitialState: ->
        addToDarkSigned: @props.toDarkSigned
        leftMenu: @props.admin_menu
        isSigned: @props.is_signed
    getDefaultProps: ->
        isSigned: false
        leftMenu: []
        addToDarkSigned: []
    
    darkSignedMenu: {
                          _class: "menu float-right", li_list: [{text: "ЛИЧНЫЙ КАБИНЕТ", href: "/cabinet"}, {text: "ВЫХОД", urlRemote: true, href: "/signout"}] 
                      }    
    updDarkSignedMenu: ->
        list = if @state.addToDarkSigned is undefined then [] else @state.addToDarkSigned
        was = @darkSignedMenu
        n = []
        if list.length > 0 
            for i in was.li_list
                n.push(i)
            for i in list
                n.push(i)
            was.li_list = n
        console.log 1
        was
    signed: ->
        React.DOM.div
            className: "row"
            React.DOM.div
                className: "medium-8 columns"
                if @state.leftMenu isnt undefined then React.createElement Menu, key: 'dark-menu-2', ulElement: @state.leftMenu
            React.DOM.div
                className: "medium-4 columns"
                React.createElement Menu, key: 'dark-menu-1', ulElement: @updDarkSignedMenu()
    unsigned: ->
        React.DOM.div
            className: "row"
            React.DOM.div
                className: "medium-12 columns"
                React.createElement Menu, key: 'dark-menu-1', ulElement: darkUnsignedMenu
                React.createElement Reveal, id: "reveal_form_window", header: "Вход на сайт"
            
    render: ->
        React.DOM.div
            id: "site-menu"
            React.DOM.div
                id: "white-menu"
                className: "top-bar"
                React.DOM.div
                    className: "row"
                    React.DOM.div
                        className: "medium-4 columns"
                        React.createElement Menu, key: 'white-menu-1', ulElement: whiteMenuLeft
                    React.DOM.div
                        className: "medium-8 columns"
                        React.createElement Menu, key: 'white-menu-2', ulElement: whiteMenuRight       
            React.DOM.div
                id: "dark-menu"
                className: "top-bar"
                if @state.isSigned 
                    @signed()
                else
                    @unsigned()
                    
                    