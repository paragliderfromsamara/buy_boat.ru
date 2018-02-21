#@BoatParameterType = React.createClass
#    render: ->
bsAttrs = ["name", "description"]

BoatSeriesTableRow = React.createClass
    editButClick: (e)->
        e.preventDefault()
        @props.setEditMode(@props.bs)
    delButClick: (e)->
        e.preventDefault()
        $.ajax(
                url: "/boat_series/#{@props.bs.id}"
                type: "DELETE"
                data: {}
                dataType: 'json'
                success: (data)=>
                    @props.delButHandle(@props.bs)
               )
    render: ->
        React.DOM.tr null,
            React.DOM.td null, @props.bs.name
            React.DOM.td null, @props.bs.description
            React.DOM.td null,
                React.DOM.a
                    onClick: @editButClick
                    React.createElement FIcon, fig: 'pencil'
            React.DOM.td null,
                React.DOM.a
                    onClick: @delButClick
                    React.createElement FIcon, fig: 'x'
                    


@BoatSeriesTable = React.createClass
    getInitialState: ->
        boat_series: @props.boat_series
        mode: 'index'
        editable_series: null
    updateTable: (bs)->
        bSeries = @state.boat_series.slice()
        if @state.mode is 'edit'
            bSeries = bSeries.map (s)-> if s.id is bs.id then bs else s                
        else
            bSeries.push(bs)
        @setState boat_series: bSeries, mode: "index"
    setEditMode: (bs)->
        @setState editable_series: bs, mode: 'edit'
    setMode: (e)->
        e.preventDefault()
        mode = if @state.mode is 'index' then 'new' else 'index'
        @setState mode: mode
    delBS: (bs)->
        bss = []
        for s in @state.boat_series
            if bs.id isnt s.id then bss.push(s)
        @setState boat_series: bss
        
    drawTable: ->
        React.DOM.div
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.div
                    className: 'button-group'
                    React.DOM.a
                        className: 'button'
                        ref: 'new'
                        onClick: @setMode
                        React.createElement IconWithText, fig: "plus", txt: "Создать новую серию"
                React.DOM.table
                    id: "boat_series_table"
                    React.DOM.thead null,
                        React.DOM.tr null,
                            React.DOM.th null, "Название"
                            React.DOM.th null, "Описание"
                            React.DOM.th null, null
                            React.DOM.th null, null
                    React.DOM.tbody null,
                        for bs in @state.boat_series
                            React.createElement BoatSeriesTableRow, key: "boat_series_#{bs.id}", bs: bs, setEditMode: @setEditMode, delButHandle: @delBS
    
    render: ->
        React.DOM.div null,
            switch @state.mode
                when 'index'
                    @drawTable()
                when 'edit'
                    React.createElement BoatSeriesForm, bs: @state.editable_series, responseHandle: @updateTable, backHandle: @setMode
                when 'new'
                    React.createElement BoatSeriesForm, responseHandle: @updateTable, backHandle: @setMode

@BoatSeriesForm = React.createClass
    getInitialState: ->
        boat_series: if @props.bs is undefined then null else @props.bs
        name: if @props.bs is undefined then "" else @props.bs.name
        description: if @props.bs is undefined then "" else @props.bs.description
    isEdit: ->
        @state.boat_series isnt null
    bsData: ->
        {
            name: @state.name
            description: @state.description
        }
    submitHandle: (e)->
        e.preventDefault()
        $.ajax(
                url: if @isEdit() then "/boat_series/#{@state.boat_series.id}" else "/boat_series"
                type: if @isEdit() then "PUT" else "POST"
                data: {boat_series: @bsData()}
                dataType: "json"
                success: (data)=> @props.responseHandle(data)
                error: (jqXHR)=> @setState errors: GetErrorsFromResponse(jqXHR.responseJSON, bsAttrs)
              )
    changeHandle: (e)->
        val = e.target.value
        @setState "#{e.target.name}" : val
    render: ->
        React.DOM.form
            onSubmit: @submitHandle
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.div
                        className: 'button-group'
                        React.DOM.button
                            className: 'button'
                            type: 'submit'
                            React.createElement IconWithText, fig: "save", txt: if !@isEdit() then "Создать" else "Сохранить изменения"
                        React.DOM.a
                            className: 'button'
                            onClick: @props.backHandle
                            React.createElement IconWithText, fig: "arrow-left", txt: "К списку серий"
            React.DOM.div
                className: 'row'
                React.DOM.div
                    className: 'small-12 medium-3 columns'
                    React.DOM.label
                        "Название"
                        React.DOM.input
                            type: 'text'
                            onChange: @changeHandle
                            name: "name"
                            value: @state.name
                React.DOM.div
                    className: 'small-12 medium-5 columns end'
                    React.DOM.label
                        "Описание"
                        React.DOM.textarea
                            onChange: @changeHandle
                            name: "description"
                            value: @state.description
            
                            
                    
