#@BoatParameterType = React.createClass
#    render: ->


@BoatParameterTypeRow = React.createClass
    getInitialState: ->
        parent: @props.parent
        type: @props.type
        edit_mode: false
    getDefaultProps: ->
        parent: null
        type: null
        edit_mode: false
    editRow:->
        winParams = {
                    winId: "#parameter_type_reveal"
                    loadEl: "#boat_parameter_type_form"
                    url: "/boat_parameter_types/#{@state.type.id}/edit?nolayout=true"
                    winHeader: "Редактирование типа параметра"
                    }
        getRemoteForm(winParams)
    toggleHandle: (e)->
        e.preventDefault()
        @setState edit_mode: !@state.edit_mode
    moveDown: ->
        @changeNumber(1)
    moveUp: ->
        @changeNumber(-1)
    changeNumber: (delta)->
        types = @state.parent.state.types
        nextNumber = @state.type.number-1 + delta
        if (nextNumber is types.length || nextNumber is -1)
            nextNumber = if nextNumber is -1 then types.length-1 else 0
            newArr = []
            @state.type.number = nextNumber+1
            if nextNumber is 0 
                newArr[0] = @state.type
                for i in [0..types.length-2]
                    types[i].number = newArr.length + 1
                    newArr[newArr.length] = types[i]
                types = newArr
            else
                for i in [1..types.length-1]
                    types[i].number = newArr.length + 1
                    newArr[newArr.length] = types[i]
                newArr[newArr.length] = @state.type
                types = newArr 
        else
            cur = @state.type
            next = types[nextNumber]
            types[next.number-1] = cur
            types[cur.number-1] = next
            for i in [0..types.length-1]
                types[i].number = i+1
        @state.parent.setState types: types

    render: ->
        React.DOM.tr null,
            React.DOM.td null, @state.type.number
            React.DOM.td null, @state.type.name
            React.DOM.td null, @state.type.short_name
            React.DOM.td null, @state.type.measure
            React.DOM.td null, @state.type.value_type
            React.DOM.td null,
                React.createElement(FIcon, key: @state.type.id, fig: @state.type.is_use_on_filter)
            React.DOM.td null, 
                React.DOM.a 
                    onClick: if @state.parent.state.isReorderMode then @moveDown else @editRow
                    id: "down",
                    if @state.parent.state.isReorderMode 
                        React.DOM.i
                            className: "fi-arrow-down"
                    else
                        React.DOM.i
                            className: "fi-pencil"
            React.DOM.td null,
                if @state.parent.state.isReorderMode 
                    React.DOM.a
                       onClick: @moveUp
                       id: "up",
                           React.DOM.i
                               className: "fi-arrow-up"
                else
                    React.DOM.a
                       "data-remote": true
                       "data-method": "DELETE"
                       href: "/boat_parameter_types/#{@state.type.id}"
                       "data-confirm": "При удалении, данный параметр исчезнет со всех лодок. Продолжить?"
                       id: "delete_parameter_type",
                           React.DOM.i
                               className: "fi-x"

@BoatParameterTypesTable = React.createClass
    getInitialState: ->
       types: @props.data
       isReorderMode: false
    getDefaultProps: ->
       types: []
    
    newTypeForm: -> 
       winParams = {
                   winId: "#parameter_type_reveal"
                   loadEl: "#boat_parameter_type_form"
                   url: "/boat_parameter_types/new?nolayout=true"
                   winHeader: "Новый тип параметра"
                   }
       getRemoteForm(winParams) 
    reorderModeToggle: (e)->
        e.preventDefault()
        if !@state.isReorderMode
             @setState isReorderMode: !@state.isReorderMode 
        else
            d = ""
            d += "number_#{@state.types[i].id}=#{@state.types[i].number}#{if i < @state.types.length-1 then "&" else ""}" for i in [0..@state.types.length-1]
            $.ajax
               method: 'POST'
               url: "/reorder_boat_parameter_types"
               dataType: 'JSON'
               data: d
               success: (data) =>
                 @setState isReorderMode: !@state.isReorderMode
                 console.log data.status
               error: ->
                   alert "Не удалось обновить таблицу" 
    render: ->
        React.DOM.div null,
            React.DOM.table null,
               React.DOM.thead null,
                    React.DOM.tr null,
                        React.DOM.th null,
                            "#"
                        React.DOM.th null,
                            "Наименование полностью"
                        React.DOM.th null,
                            "Сокращенно"
                        React.DOM.th null,
                            "Мера"
                        React.DOM.th null,
                            React.DOM.span
                                "data-tooltip": true
                                "aria-haspopup":true
                                className: "has-tip top"
                                title: "В зависимости от выбранного типа параметра, фильтр будет подбирать способы сортировки."
                                "Тип"
                        React.DOM.th null,
                            React.DOM.span
                                "data-tooltip": true
                                "aria-haspopup":true
                                className: "has-tip top"
                                title: "Если выбрано ДА, то на странице выбора лодки будет возможным фильтровать по его значению"
                                "Вкл. в фильтр"
                        React.DOM.th
                            colSpan: 2,
                            React.DOM.a
                                onClick: @reorderModeToggle
                                if @state.isReorderMode then "Сохранить" else "Изменить порядок"
               React.DOM.tbody null,
                     for type in @state.types
                         React.createElement(BoatParameterTypeRow, key: type.id, type: type, parent: @)
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: "small-12 columns"
                    React.DOM.a
                        onClick: @newTypeForm
                        className: "button"
                        React.DOM.i
                            className: "fi-plus"
                            " "
                        React.DOM.span null, "Добавить новый тип параметра"
            React.createElement Reveal, id: "parameter_type_reveal", header: "Изменить тип параметра", size: "full"
            $("[data-dropdown]").foundation()               
                       
                   
                   
                   
                            
                    
