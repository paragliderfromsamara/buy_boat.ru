
@MenuItem = React.createClass

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
        if @props.menu_item.url is "/signin"
            React.DOM.li null,
                React.DOM.a
                    onClick: @initSessionForm
                    @props.menu_item.name   
            
        else if @props.menu_item.url is "/signout"
            React.DOM.li null,
                React.DOM.a
                    href: @props.menu_item.url
                    "data-remote": true
                    @props.menu_item.name
                    
        else if @props.menu_item.url is "/signup"
            React.DOM.li null,
                React.DOM.a
                    onClick: @initRegistrationForm
                    @props.menu_item.name                    
        else
            React.DOM.li null,
                React.DOM.a
                    href: @props.menu_item.url
                    React.DOM.span null, 
                        @props.menu_item.name
                if @props.menu_item.dropdown isnt undefined 
                    j = 0
                    React.DOM.ul 
                        className: "menu vertical",
                        React.createElement MenuItem, key: j++, menu_item: sub_item for sub_item in @props.menu_item.dropdown
                                
                        
        
                    
@MenuItems = React.createClass
    getInitialState: ->
        session_menu_items: @props.data.right
        menu_items: @props.data.left
    getDefaultProps: ->
        session_menu_items: []
        menu_items: []
    render: ->
       needForm = false
       i = 0
       React.DOM.div
           className: "top-bar"
           React.DOM.div
               className: "row"
               React.DOM.div
                   className: "small-12 columns"
                   React.DOM.div
                       className: "top-bar-left"
                       React.DOM.ul
                           className: "dropdown menu"
                           "data-dropdown-menu": ""
                           for item in @state.menu_items    
                               React.createElement MenuItem, key: i++, menu_item: item
                   React.DOM.div
                       className: "top-bar-right"
                       React.DOM.ul
                           className: "dropdown menu"
                           "data-dropdown-menu": true 
                           for item in @state.session_menu_items
                               needForm = if not needForm then item.url == "/signin" else needForm 
                               React.createElement MenuItem, key: i++, menu_item: item
                   if needForm then React.createElement Reveal, id: "reveal_form_window", header: "Вход на сайт"
               
        


    



    