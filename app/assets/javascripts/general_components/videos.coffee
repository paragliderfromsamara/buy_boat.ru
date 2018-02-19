@VideoViewer = React.createClass
    delAct: (e)->
        e.preventDefault()
        @props.removeAction(@props.video)
    render: ->
        React.DOM.div
            className: 'column'
            if @props.removeAction isnt undefined
                React.DOM.a
                    className: 'button alert'
                    onClick: @delAct
                    React.createElement IconWithText, txt: 'Удалить', fig: 'trash'
            React.DOM.div
                className: 'responsive-embed'
                React.DOM.iframe
                    width: 420
                    height: 315
                    src: @props.video.url
                    frameBorder: 0
                    allowFullScreen: true