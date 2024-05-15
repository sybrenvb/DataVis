<script>
    export let width;
    export let height;
    export let margin;
    export let label;
    export let yoffset;
    export let xoffset;
    export let labelforx = false;
    export let labelfory = false;
    export let textanchor = 'end';
  </script>
  
  {#if width}
    <g class="labels-x-y text-sm">
      {#if labelforx}
        <text
          fill="black"
          x={+margin.left + width +100 + xoffset}
          y={+height + margin.top - 40 + yoffset}
          text-anchor={textanchor}>{label}</text>
      {/if}
      {#if labelfory}
        <text
          fill="black"
          x={+margin.left + xoffset}
          y={-margin.top + 80 + yoffset}
          text-anchor={textanchor}>{label}</text>
      {/if}
    </g>
  {/if}