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
        header: ""
        enableClose: true
        data: ""
        size: "small"
    render: ->
        React.DOM.div
            "data-reveal":true
            id: @state.id
            className: "#{@state.class} #{@state.size}"
            if @state.header isnt ""
                React.DOM.h3 null,
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
    

    