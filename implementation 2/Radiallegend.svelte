<script>
    export let radiusScale;
    export let radialLegendData = [3000, 30000, 300000];
  
  </script>
  
  <g fill="black">
    <text x="700" y="280" text-anchor="middle"
      >quantity of purchases</text>
    {#each radialLegendData as d,i}
      <circle
        cx="700"
        cy={300+20*i+radiusScale(d)}
        r={radiusScale(d)} />
  
      <text x="750" y={300+20*i+radiusScale(d)}
        >{d}</text>
    {/each}
  </g>
    