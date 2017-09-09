
@User = React.createClass
    render: ->
        React.DOM.tr null,
            React.DOM.td null, @props.user.email
            React.DOM.td null, @props.user.first_name
            React.DOM.td null, @props.user.last_name
            React.DOM.td null, @props.user.third_name
            React.DOM.td null, @props.user.user_type
            React.DOM.td null, 
                React.DOM.a
                    href: "/users/#{@props.user.id}",
                    "Подробнее"
                    

@Users = React.createClass
    getInitialState: ->
       users: @props.data
    getDefaultProps: ->
       users: []
    render: ->
      React.DOM.div
        className: "row"
        React.DOM.div
            className: 'small-12 columns users'
            React.DOM.table
                className: "users-list"
                React.DOM.thead null,
                    React.DOM.tr null,
                        React.DOM.th null, "Email"
                        React.DOM.th null, "Имя"
                        React.DOM.th null, "Фамилия"
                        React.DOM.th null, "Отчество"
                        React.DOM.th null, "Тип"
                        React.DOM.th null, null
                React.DOM.tbody null,
                    for user in @state.users
                        React.createElement User, key: user.id, user: user
    
