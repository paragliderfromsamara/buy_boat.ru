defaultShowTime = 400
@ShowEl = (sel, t)-> $("#{sel}").fadeIn(if t is undefined then defaultShowTime else t)