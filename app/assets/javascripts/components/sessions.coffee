
SessionMenuItem = React.createClass

    initRegistrationForm: ->
        winParams = {
                    winId: "#reveal_form_window"
                    loadEl: "#user_form"
                    url: "/signup?nolayout=true"
                    winHeader: "Регистрация на сайте"
                    }
        getRemoteForm(winParams)
    
    initSessionForm: ->
        winParams = {
                    winId: "#reveal_form_window"
                    loadEl: "#session_form"
                    url: "/signin?nolayout=true"
                    winHeader: "Вход на сайт"
                    }
        getRemoteForm(winParams)        
    
    render: -> 
        if @props.session_menu_item.url is "/signin"
            React.DOM.li null,
                React.DOM.a
                    onClick: @initSessionForm
                    @props.session_menu_item.name   
            
        else if @props.session_menu_item.url is "/signout"
            React.DOM.li null,
                React.DOM.a
                    href: @props.session_menu_item.url
                    "data-remote": true
                    @props.session_menu_item.name
                    
        else if @props.session_menu_item.url is "/signup"
            React.DOM.li null,
                React.DOM.a
                    onClick: @initRegistrationForm
                    @props.session_menu_item.name                    
        else
            React.DOM.li null,
                React.DOM.a
                    href: @props.session_menu_item.url,
                    @props.session_menu_item.name
        
                    
@SessionMenuItems = React.createClass
    getInitialState: ->
        session_menu_items: @props.data
    getDefaultProps: ->
        session_menu_items: []
    render: ->
       needForm = false
       React.DOM.div null,
           React.DOM.ul null,
               for item in @state.session_menu_items
                   needForm = if not needForm then item.url == "/signin" else needForm 
                   React.createElement SessionMenuItem, key: item.url, session_menu_item: item    
           if needForm then React.createElement Reveal, id: "reveal_form_window", header: "Вход на сайт"
               
        


    



    