@RCHeader = React.createClass
    render: ->
        React.DOM.div
            id: 'rc-header'
            if @props.h3 isnt undefined
                React.DOM.h3 null, @props.h3.toUpperCase()
            if @props.h1 isnt undefined
                React.DOM.h1 null, @props.h1.toUpperCase()
            if @props.h4 isnt undefined
                React.DOM.h4 null, @props.h4.toUpperCase()

@RCSlider = React.createClass
    truncatedDesc: ->
        d = @props.description
        if d.length > 380
            d.slice(0, 380) + '...'
        else
            d
    fogVol: ->
        if @props.fogVol isnt undefined then "#{@props.fogVol}-fog" else "medium-fog"
    fogColor: ->
        if @props.fogColor isnt undefined then "#{@props.fogColor}-bg" else "white-bg"
    fog: ->
        React.DOM.div
            className: "rc-fog #{@fogVol()} #{@fogColor()}"
    sliderText: ->
        React.DOM.div
            id: 'slogan'
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 medium-6 large-5 columns'
                    if @props.header isnt undefined
                        React.DOM.div 
                            className: 'tb-pad-s'
                            @props.header
                    if @props.description isnt undefined 
                        React.DOM.p
                            className: 'show-for-large'
                            title: @props.description
                            @truncatedDesc()
                React.DOM.div
                    className: 'medium-5 large-5 medium-offset-1 large-offset-2 columns hide-for-small-only'
                    if @props.slogan isnt undefined
                        React.DOM.p
                            id: 'rc-boat-slogan'
                            className: 'text-center tb-pad-m hide-for-small'
                            @props.slogan.toUpperCase()
    render: ->
        if @props.photos.length > 0
            React.DOM.div
                className: 'orbit'
                role: 'region'
                'aria-label': 'Realcraft Motor Boats'
                'data-orbit': ''
                'data-options': 'animInFromLeft:fade-in; animInFromRight:fade-in; animOutToLeft:fade-out; animOutToRight:fade-out;'
                if @props.fogColor isnt undefined or @props.fogVol isnt undefined then @fog()
                @sliderText()
                React.DOM.ul
                    className: 'orbit-container'
                    for i in [0..@props.photos.length-1]
                        React.createElement RCSliderPhotoItem, key: "slider-item-#{i}", p: @props.photos[i], isActive: i is 0
        else null
                    
@RCSliderPhotoItem = React.createClass
    render: ->
        React.DOM.div
            className: "#{if @props.isActive then 'is-active ' else ''} orbit-slide rc-slide"
            style: {backgroundImage: "url('#{@props.p.small}')"}
            'data-interchange': MakeInterchangeData(@props.p, true),
            null

            