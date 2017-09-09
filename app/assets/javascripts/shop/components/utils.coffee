#<div class="reveal" id="exampleModal9" data-reveal data-overlay="false">
#  <p>I feel so free!</p>
#  <button class="close-button" data-close aria-label="Close reveal" type="button">
#    <span aria-hidden="true"></span>
#  </button>
#</div>

#загружаем удаленную форму в reveal контейнер

@FIcon = React.createClass
    render: ->
        React.DOM.i
            className: "fi-#{@props.fig}",
            " "
            
@IconWithText = React.createClass
    render: ->
        React.DOM.span null, 
            React.createElement FIcon, fig: @props.fig
            React.DOM.span null, @props.txt
        
@getRemoteForm = (p)->
    c = $(p.winId).find("#reveal_content")
    if p.winHeader isnt undefined then $(p.winId).find("h3").html p.winHeader
    c.load "#{p.url} #{p.loadEl}", ()-> 
            c.find("form").attr("data-remote", "true") 
            $(p.winId).foundation('open')
            $(p.winId).find("[data-dropdown]").foundation()

@fillErrorsInForm = (errors, formId)->
    f = document.getElementById("formId")
    if errors.length > 0 && f isnt null
        for e in errors
            console.log e.message
        


@Reveal = React.createClass
    getInitialState: ->
       id: @props.id
       class: @props.class
       header: @props.header
       enableClose: @props.enableClose
       data: @props.data
       size: @props.size
    getDefaultProps: ->
        id: "default_reveal"
        class: "reveal"
        enableClose: true
        data: ""
        size: "small"
    componentDidMount: ->
        if @props.didMountAction isnt undefined then @props.didMountAction()
    componentWillUnmount: ->
        if @props.willUnmountAction isnt undefined then @props.willUnmountAction()
    render: ->
        React.DOM.div
            "data-reveal":true
            id: @state.id
            className: "#{@state.class} #{@state.size}"
            if @state.header isnt undefined
                React.DOM.div
                    className: 'row'
                    React.DOM.div
                        className: "small-12 columns"
                        React.DOM.h3
                            id: "reveal_header", 
                            "#{@state.header}"
            if @state.enableClose 
                React.DOM.button
                    className: "close-button"
                    "data-close": "#{@state.id}"
                    type: "button",
                    React.DOM.span 
                        "aria-hidden":true
                        "x"
            React.DOM.div
                id: "reveal_content"
                @state.data
                
#{text: "КупитьЛодку.рф", href: "/", className: "logo-field"}
@LiItem = React.createClass
    render: ->
        React.DOM.li
            className: @props.liElement.className,
            if @props.liElement.href isnt undefined || @props.liElement.urlClickHandle isnt undefined
                React.DOM.a
                    onClick: @props.liElement.urlClickHandle
                    "data-remote": @props.liElement.urlRemote
                    href: @props.liElement.href
                    @props.liElement.text
            else
                React.DOM.span null, @props.liElement.text

#{text: "КупитьЛодку.рф", href: "/", className: "logo-field"}
@Menu = React.createClass
    getInitialState: ->
       id: @props.ulElement.id
       _class: @props.ulElement._class
       liList: @props.ulElement.li_list
    getDefaultProps: ->
        id: ""
        _class: ""
        liList: []
    render: ->
        i = 0
        React.DOM.ul
            id: @state.id
            className: @state._class
            for li in @state.liList
                React.createElement LiItem, {key: i++, liElement: li}

@PhotoSimpleSlider = React.createClass
    render: ->
        idx = jdx = -1
        React.DOM.div
            className: 'orbit'
            id: "b-img-slider"
            role: "region"
            "data-orbit": ''
            "aria-label": 'Изображения лодки'
            React.DOM.ul
                className: "orbit-container"
                React.DOM.button
                    className: "orbit-previous"
                    React.DOM.span
                        className: "show-for-sr"
                        "Пред."
                    React.DOM.i
                        className: "fi-arrow-left"
                React.DOM.button
                    className: "orbit-next"
                    React.DOM.span
                        className: "show-for-sr"
                        "След."
                    React.DOM.i
                        className: "fi-arrow-right"
                for p in @props.phs
                    idx++
                    React.DOM.li
                        key: "slider-item-#{idx}"
                        className: "orbit-slide"
                        React.DOM.img
                            className: "orbit-image"
                            src: p.wide_medium

                            
   
      