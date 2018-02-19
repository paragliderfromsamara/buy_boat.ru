#@BoatParameterType = React.createClass
#    render: ->

@GetYouTubeUrl = (str)->
    if str is null || str is undefined then return null
    re = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=(player_detailpage|player_embedded)&amp;v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/ 
    match = re.exec(str)
    if match is null then null else "https://www.youtube.com/embed/#{match[4]}"
    
@ErrorsCallout = React.createClass
    render: ->
        if @props.errors.length is 0 then null
        else
            idx = 0
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.div
                        className: 'callout alert'
                        React.DOM.ul null
                            for err in @props.errors
                                idx++
                                React.DOM.li
                                    type: '1'
                                    key: "err-#{idx}",
                                    err

simpleMenuItem = React.createClass
    handleClick: (e)->
        e.preventDefault()
        @props.clickItemEvent(@props.item)
    render: ->
        React.DOM.li
            style: if @props.isActive then {backgroundColor: '#cee7ff'}
            React.DOM.a
                onClick: @handleClick
                @props.item[@props.nTitle]

@SimpleMenu = React.createClass
    getInitialState: ->
        nTitle: if @props.nTitle is undefined then 'name' else @props.nTitle
    render: ->     
        React.DOM.div 
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.ul
                    className: 'menu'
                    for item in @props.items
                        React.createElement simpleMenuItem, key: "item-#{item.id}", item: item, nTitle: @state.nTitle, clickItemEvent: @props.clickItemEvent, isActive: @props.selected is item
                
@MiniPhotoUploader = React.createClass
    componentDidMount: ->
        @initLoader()
    dzElementId: ->
        "#{@props.entity}-#{@props.attr}-dz"
    initLoader: ->
        $("div##{@dzElementId()}").dropzone(
                { 
                    url: @props.url 
                    method: 'PUT'
                    maxFiles: 1
                    paramName: "#{@props.entity}[#{@props.attr}]"
                    dictDefaultMessage: "Выберите файл <i class = \"fi-upload fi-large\"></i>"
                    sending: (file, xhr, formData)=>
                        formData.append("authenticity_token", @props.form_token)
                    success: (file, response)=> 
                        @props.handleSuccess(response)
                        
                })
    render: ->
        React.DOM.div 
            id: @dzElementId()
            className: 'dropzone'
            null

@HeaderWithSubHeader = React.createClass
    render: ->
        React.DOM.div
            className: 'kra-header'
            if @props.h3 isnt undefined
                React.DOM.h3 null, @props.h3.toUpperCase()
            if @props.h1 isnt undefined
                React.DOM.h1 null, @props.h1.toUpperCase()
            if @props.h4 isnt undefined
                React.DOM.h4 null, @props.h4.toUpperCase()      


            
        
        