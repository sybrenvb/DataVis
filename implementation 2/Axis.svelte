<script>
  import { select } from 'd3-selection';
  import { axisBottom, axisLeft } from 'd3-axis';
  import { format } from 'd3-format';

  export let width;
  export let height;
  export let margin;
  export let position;
  export let scale;
  export let tick_outer;
  export let tick_number;
  export let to_format;
  export let no_domain;
  export let formatString = '$.0f';
  export let format_mobile;
  const formatMobile = (tick) => {
  return "'" + tick.toString().slice(13, 15);
};

const formatter = format(formatString);
let transform;
let g;

$: {
  select(g).selectAll('*').remove();

  let axis;

  if (width && scale) {
    switch (position) {
      case 'bottom':
        if (format_mobile) {
          axis = axisBottom(scale)
            .tickValues([4,5,6,7,8])
            .tickSizeOuter(tick_outer || 0);
          transform = `translate(0, ${height - margin.bottom})`;
        } else {
          axis = axisBottom(scale)
            .tickValues([4,5,6,7,8])
            .tickSizeOuter(tick_outer || 0);
          transform = `translate(0, ${height - margin.bottom})`;
        }
        break;
      case 'left':
        if (to_format) {
          axis = axisLeft(scale)
            .tickSizeOuter(tick_outer || 0)
            .tickFormat((d) => formatter(d))
            .ticks(tick_number || 5);
          transform = `translate(${margin.left}, 0)`;
        } else {
          axis = axisLeft(scale)
            .ticks(tick_number || 5)
            .tickSizeOuter(tick_outer || 0);
          transform = `translate(${margin.left}, 0)`;
        }
    }

    if (no_domain) {
      select(g).call(axis).select('.domain').remove();
    } else {
      select(g).call(axis);
    }
  }
}
</script>

<g class="axis" bind:this={g} {transform} />

<style>
.axis {
  shape-rendering: crispEdges;
}
</style>