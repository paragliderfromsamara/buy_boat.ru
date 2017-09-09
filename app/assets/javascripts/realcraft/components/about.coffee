#@BoatParameterType = React.createClass
#    render: ->

@AboutPage = React.createClass
    getInitialState: ->
       locale: @props.data.locale
       texts: @props.data.parameters
       photos: @props.data.photos
          
    render: ->
        React.DOM.div