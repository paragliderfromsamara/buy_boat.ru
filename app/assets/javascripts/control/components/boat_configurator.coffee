#@BoatParameterType = React.createClass
#    render: ->

tryConvToNum = (str)->
    v = parseInt(str, 10)
        #val = if val isnt NaN then val else s
    return if v isnt NaN then v else str 
    
parseArray = (str, isNum)->
    arr = if str.indexOf(",") is -1 then [str] else str.split(/,/)
    arr = if isNum then arr.map((item)-> tryConvToNum(item)) else arr
    return arr   

logical = (arr, entities)->
        # Первый параметр (элемент массива) - тип проверки аргументов, второй - операция над аргументами
        # 1 = 'Y' - Yes or 'N'- No, 2 = '&' - And or '|' - Or
        # True_If_Yes_And_Yes, True_If_No_And_No, True_If_Yes_Or_Yes, True_If_No_Or_No
        if arr.length < 3 then return false # Для пустого массива параметров - всегда возврат ЛОЖЬ
        v = arr[1] is '|' 
        for i in [2..arr.length-1]
            idx = parseInt arr[i]
            if entities[idx] is undefined then continue
            if arr[0] is "Y"
                if arr[1] is '|' then v |= entities[idx].checked else v &= entities[idx].checked
            else
                if arr[1] is '|' then v |= !entities[idx].checked else v &= !entities[idx].checked 
        return v    


updEntities = (elId, arr)->
    #сброс флажков
    if elId > 0 
        if not arr[elId].enabled then return arr
        arr[elId].checked = !arr[elId].checked
    actions = ['reset', "set", "disable"]
    for act in actions 
        arr.map (e)->
            if e isnt undefined
                isOption = e.rec_type is "Стандарт" or e.rec_type is "ВЫБОР"
                if e.arr_id isnt elId
                    if isOption and act is "reset" then e.checked = (if logical(e.de_sel_if_y, arr) or logical(e.de_sel_if_n, arr) then false else e.checked)
                    else if isOption and act is "set" then e.checked = (if logical(e.de_sel_if_y, arr) or logical(e.de_sel_if_n, arr) then false else (if logical(e.sel_if_y, arr) or logical(e.sel_if_n, arr) then true else e.checked))
                    else if isOption and act is "disable" then e.enabled =  (if logical(e.dis_if_y, arr) or logical(e.dis_if_n, arr) then false else (if logical(e.en_if_y, arr) or logical(e.en_if_n, arr) then true else e.start_enabled))
            return e
    return arr    
        


      
prepareData = (data, type)->
    stepNum = 1
    groups = new Array()
    entities = new Array()
    for d in data
        d.rec_level = parseInt(d.rec_level, 10)
        d.std_comp_sostav = parseArray(d.std_comp_sostav, true)
        d.std_comp_option = parseArray(d.std_comp_option, true)
        d.std_comp_select = parseArray(d.std_comp_select, true)
        d.std_comp_enable = parseArray(d.std_comp_enable, true)
        d.std_comp_prefer = parseArray(d.std_comp_prefer, true)
        d.level_checked = parseArray(d.level_checked, true)
        d.sel_if_y = parseArray(d.sel_if_y, false)
        d.sel_if_n = parseArray(d.sel_if_n, false)
        d.de_sel_if_y = parseArray(d.de_sel_if_y, false)
        d.de_sel_if_n = parseArray(d.de_sel_if_n, false)
        d.dis_if_y = parseArray(d.dis_if_y, false)
        d.dis_if_n = parseArray(d.dis_if_n, false)
        d.amount = parseArray(d.amount, true)
        entities[d.arr_id] = d
        
    return updEntities(0, entities)

@BoatOptionRow = React.createClass
    isEnabled: -> @props.option.enabled
    isSelected: -> @props.option.checked
    rowClass: ->
        if @isEnabled() 
            return if @isSelected() then "selected" else ''
        else 'disabled'
    selectHandle: (e)->
        e.preventDefault()
        @props.parent.setState data: updEntities(@props.option.arr_id, @props.parent.state.data)
    render: ->
        offset = if @props.option.rec_level > 0 then @props.option.rec_level-1 else 0
        rc = 8-offset
        cn = "small-#{rc} columns"
        React.DOM.div
            className: "row #{@rowClass()}" 
            React.DOM.div
                className: "small-1 #{if offset > 0 then "small-offset-#{offset}"} columns"
                React.DOM.a
                    onClick: @selectHandle
                    React.DOM.i
                        className: if @isSelected() then "fi-check" else "fi-x"
            React.DOM.div
                className: cn
                React.DOM.p null, @props.option.param_name
            React.DOM.div 
                className: "small-2 columns"
                React.DOM.p
                    className: "option-cost"
                    if $.trim(@props.option.price) isnt "" && $.trim(@props.option.price) isnt "0" then @props.option.price else ""
            React.DOM.div 
                className: "small-2 columns"
                ""


@OptionGroup = React.createClass
    render: ->
        rl = @props.group.rec_level
        offset = if rl > 0 then rl-1 else 0
        rc = 8 - offset
        offsetClassName = if offset > 0 then  " small-offset-#{offset} " else ""
        React.DOM.div
            className: "group-container"
            "data-step-content": if @props.stepId isnt -1 then @props.stepId else null 
            React.DOM.div
                className: "row dark-blue-bg"
                React.DOM.div
                    className: "small-#{rc} #{offsetClassName} columns group-control"
                    id: "group-#{@props.group.arr_id}"
                    React.DOM.h5 null, "#{@props.group.param_name}" 
                React.DOM.div
                    className: "small-4 columns text-right",
                    React.DOM.p 
                        className: "group-cost"
                        id: "group-coast-#{@props.group.arr_id}",
                        "100500 р."
                        

@StepTitle = React.createClass
    render: ->
        React.DOM.div
            className: "row"
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.h4 null,
                    React.DOM.span
                        className: 'subheader'
                        "Шаг #{@props.stepId}: "
                    React.DOM.span null, @props.group.param_name

@ConfiguratorStep = React.createClass
    setStepHandler: ->
        @props.configurator.setStep(@props.idx)
    isCurStep: ->
        @props.configurator.state.curStep is @props.idx and @props.configurator.state.curStep > 0 and @props.configurator.state.viewMode is "oneStep"
    render: ->
        React.DOM.a
            className: if @isCurStep() then "button rc-primary-blue" else "button rc-blue"
            onClick: @setStepHandler
            React.DOM.p null,
                "Шаг #{@props.idx}:"
            React.DOM.p null,
                "#{@props.g.param_name.split(/\s+/)[0]}"



@BoatConfigurator = React.createClass
    getInitialState: ->
       isNeedUpd: true
       data: prepareData(@props.data)
       viewMode: 'oneStep' # режим отображения таблиц [oneStep, result, allSteps]
       curStep: 1 # номер текущего шага
    getDefaultProps: ->
       data: []
       curStep: -1 
        #if @state.isFirstDraw then @setState isFirstDraw: false
    isItStep: (e)-> e.rec_level is 1 and e.rec_type is "Группа"
    updOptions: (id)->
       @setState data: updEntities(id, @state.data)  
       return true
    setStep: (id)->
        @setState curStep: id, viewMode: "oneStep"
    showAllSteps: ->
        @setState curStep: -1, viewMode: "allSteps"
    
    render: ->
        curStepDrawNow = false #переменная говорящая, что сейчас отрисовывается текущий шаг
        stepId = 0
        s = 0
        React.DOM.div
            id: "configurator",
            React.DOM.div 
                className: "row"
                React.DOM.div 
                    className: "small-12 columns"
                    React.DOM.div
                        className: "button-group"
                        for g in @state.data
                            if g is undefined then continue
                            if not @isItStep(g) then continue
                            s++
                            React.createElement ConfiguratorStep, key: "step-but-#{s}", g: g, idx: s, configurator: @
                        React.DOM.a
                            className: "button secondary"
                            onClick: @showAllSteps
                            React.DOM.p null, "Все"
                            React.DOM.p null, "шаги"
            React.DOM.div 
                className: "row",
                React.DOM.div
                    className: "small-6 columns"
                    React.DOM.h3 null,
                        "Общая стоимость лодки"
                    React.DOM.p
                        id: 'sum-boat-coast'
                        className: "stat"
                        "0"
                React.DOM.div
                    className: "small-6 columns",
                    React.DOM.h3 null,
                        "Стоимость опций"
                    React.DOM.p
                        id: 'option-coast'
                        className: "stat"
                        "0"
            for e in @state.data
                if e is undefined then continue
                if @isItStep(e) then stepId++
                if @state.viewMode is "oneStep"
                    if stepId < @state.curStep then continue
                    if stepId > @state.curStep then break
                if @isItStep(e)
                    React.createElement StepTitle, key: e.arr_id, stepId: stepId, group: e
                else if e.rec_type is "Группа"
                    React.createElement OptionGroup, key: e.arr_id, group: e
                else if e.rec_type is "ВЫБОР" || e.rec_type is "Стандарт"
                    React.createElement BoatOptionRow, key: e.arr_id, option: e, parent: @

               
                                      
