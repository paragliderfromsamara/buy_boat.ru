#@BoatParameterType = React.createClass
#    render: ->
    
YouTubeVideoFrame = React.createClass
    getInitialState: ->
        width: if @props.width is undefined then '496' else @props.width
        height: if @props.height is undefined then '279' else @props.height
    render: ->
        React.DOM.div
            className: 'flex-video widescreen'
            React.DOM.iframe
                width: @state.width
                height: @state.height
                frameBorder: '0'
                allowFullScreen: ''
                src: @props.url

VideoColumn = React.createClass
    render: ->
        React.DOM.div
            className: 'column'
            React.DOM.div
                className: 'flex-vide widescreen'
                React.createElement YouTubeVideoFrame, url: @props.video.url
            
@BoatVideosList = React.createClass
    noVideos: ->
        React.DOM.div
            className: 'row tb-pad-m'
            React.DOM.div
                className: 'small-12 columns'
                Dict.no_videos_msg
    moreVideos: ->
        React.DOM.div
            className: 'row'
            for v in @props.videos
                React.DOM.div
                    className: 'small-12 medium-8 large-7 small-centered columns'
                    React.createElement YouTubeVideoFrame, key: "video-#{v.id}", url: v.url 
    render: ->
        if @props.videos.length is 0 then @noVideos()
        else @moreVideos()
    


