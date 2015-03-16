@app.factory 'TimeGraph', ->
  lineGraph = (id, startDate, endDate) ->

    padding = {top: 10, right: 10, bottom: 40, left: 70}
    unit = ''

    x = (d) -> d[0]
    y = (d) -> d[1]

    xFormat = d3.format()
    yFormat = d3.format()

    xScale = d3.time.scale()
    yScale = d3.scale.linear()

    xAxis = d3.svg.axis().scale(xScale).orient('bottom').tickPadding(15).tickSize(0)
    yAxis = d3.svg.axis().scale(yScale).orient('left').tickPadding(20).tickSize(0)

    chart = (el) ->
      el.each((data) ->

        # ----- Data ----- #

        data = data.map((d, i) ->
          [x.call(data, d, i), y.call(data, d, i)]
        )

        # ----- Setup ----- #

        chart = d3.select(this)
        width = chart[0][0].clientWidth - padding.left - padding.right
        height = 120 - padding.top - padding.bottom

        min = d3.min(data, (d) -> d[1])
        min = if min < 0 then min else 0

        xScale
          .range([0, width])
          .domain([startDate, endDate])
        yScale
          .range([height, 0])
          .domain([min, d3.max(_.filter(data, (d) -> d[0] >= startDate && d[0] <= endDate), (d) -> d[1])])

        svg = chart.selectAll('svg').data([data])

        # ----- Init ----- #

        init = svg.enter().append('svg').append('g')

        init.append('clipPath')
          .attr('id', "clip#{id}")
          .append('rect')
          .attr('width', width)
          .attr('height', height)

        init.append('clipPath')
          .attr('id', "pointclip#{id}")
          .append('rect')
          .attr('width', width)
          .attr('height', height + 12)
          .attr('transform', 'translate(0, -6)')

        init.append('g')
          .attr('class', 'chart-axis chart-axis--x')

        init.append('g')
          .attr('class', 'chart-axis chart-axis--y')

        init.append('path')
          .attr('class', 'chart-area')
          .attr('clip-path', "url(#clip#{id})")
          .attr('d',
            d3.svg.area()
              .x((d) -> xScale(d[0]))
              .y0(height)
              .y1(height)
          )

        init.append('path')
          .attr('class', 'chart-line')
          .attr('clip-path', "url(#clip#{id})")
          .attr('d',
            d3.svg.line()
              .x((d) -> xScale(d[0]))
              .y(height)
          )

        init.select('.chart-axis--y')
          .append('text')
            .attr('class', 'chart-unit')
            .attr('transform', 'rotate(-90)')
            .attr('x', -height / 2)
            .attr('y', -width - 60)
            .attr('dy', '.5em')
            .style('text-anchor', 'middle')
            .text(unit)

        # ----- Update ----- #

        svg
          .attr('width', width + padding.left + padding.right)
          .attr('height', height + padding.top + padding.bottom)

        g = svg.select('g')
          .attr('transform', "translate(#{padding.left}, #{padding.top})")

        g.select('.chart-axis--x')
          .attr('transform', "translate(0, #{height})")
          .transition()
            .duration(500)
            .ease('cubic-out')
            .call(xAxis.tickFormat(xFormat).ticks(data.length).ticks(d3.time.month, 1))

        g.select('.chart-axis--y')
          .attr('transform', "translate(#{width}, 0)")
          .transition()
            .duration(500)
            .ease('cubic-out')
            .call(yAxis.tickFormat(yFormat).tickSize(width).ticks(4))

        g.select('.chart-area')
          .transition()
            .duration(500)
            .ease('cubic-out')
            .attr('d',
              d3.svg.area()
                .x((d) -> xScale(d[0]))
                .y0(height)
                .y1((d) -> yScale(d[1]))
            )

        g.select('.chart-line')
          .transition()
            .duration(500)
            .ease('cubic-out')
            .attr('d',
              d3.svg.line()
                .x((d) -> xScale(d[0]))
                .y((d) -> yScale(d[1]))
            )

        plots = g.selectAll('.chart-plot').data((d) -> d)

        plots.enter().append('circle')
          .attr('class', 'chart-plot')
          .attr('clip-path', "url(#pointclip#{id})")
          .attr('cy', height)

        plots
          .transition()
            .duration(500)
            .ease('cubic-out')
            .attr('cx', (d) -> xScale(d[0]))
            .attr('cy', (d) -> yScale(d[1]))
            .attr('r', 6)

        plots.exit().remove()

        # ----- Interactivity ----- #

        tip = d3.tip()
          .attr('class', 'chart-label')
          .offset([-14, 0])
          .html((d) ->
            d3.time.format("%Y-%m-%d")(d[0]) + "<strong>#{d[1]} #{unit}</strong>"
          )

        svg.call(tip)

        plots
          .on('mouseover', (d) ->
            d3.select(this).classed('is-chart-active', true)
            svg.classed('is-chart-over', true)
            tip.show(d)
          )
          .on('mouseout', (d) ->
            d3.select(this).classed('is-chart-active', false)
            svg.classed('is-chart-over', false)
            tip.hide()
          )
      )

    chart.unit = (val) ->
      return unit if (!arguments.length)
      unit = val
      chart

    chart.x = (val) ->
      return x if (!arguments.length)
      x = val
      chart

    chart.y = (val) ->
      return y if (!arguments.length)
      y = val
      chart

    chart.xFormat = (val) ->
      return xFormat if (!arguments.length)
      xFormat = val
      chart

    chart.yFormat = (val) ->
      return yFormat if (!arguments.length)
      yFormat = val
      chart

    chart

  {
    draw: (element, id, data, unit, startDate, endDate) ->
      d3.selectAll(element)
        .datum(data)
        .call(
          lineGraph(id, startDate, endDate)
            .unit(unit)
            .xFormat(d3.time.format('%b %Y'))
            .x((d) -> d.time)
            .y((d) -> d.value)
        )
  }
