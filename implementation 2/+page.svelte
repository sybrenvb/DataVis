<h1>Group_09 implementation converge3 </h1>
<script>
    import { writable } from 'svelte/store';
    import interactive from '$lib/interactive.json';
    import { scaleLinear, scaleOrdinal, scaleLog } from 'd3-scale';
    import Axis from './Axis.svelte';
    import Radiallegend from './Radiallegend.svelte';
    import Labels from './Labels.svelte';
  
    //set scales and margins
  let width = 800;
  const height = 500;
  const margin = {top: 40, right: 20, bottom: 20, left: 35}
  let scaleX = scaleLinear().domain([2,10]).range([margin.left,width-margin.right]);
  let scaleY = scaleLinear().domain([0,6]).range([height-margin.bottom,margin.top]);
  let radiusScale = scaleLinear().domain([1,509105]).range([5,50])
  let colours = scaleOrdinal().domain(['1','2',]).range(['orange','fuchsia'])

   // Initialize the input values as writable stores
   const mindate = writable('2021-12-30');
    const maxdate = writable('2025-01-11');
    let dataScatterplot = calculateSumMean(interactive, '2023-06-11', '2023-07-11');
  
    // Subscribe to changes in input values and recalculate the sum
    $: {
      const mindateValue = $mindate;
      const maxdateValue = $maxdate;
      dataScatterplot = calculateSumMean(interactive, mindateValue, maxdateValue);
    }
     // Function to calculate the sum and mean based on date range
     function calculateSumMean(interactive, mindate, maxdate) {
      const PurchaseOrderQuantityArray = interactive.PurchaseOrderQuantity;
      const plantKeys = interactive.PlantKey;
      const materialKeys = interactive.MaterialKey;
      const actualArrivalDates = interactive.ActualArrivalDateYard;
      const daysTooLate = interactive.DaysTooLate;
      const sums = [];
  
      for (let i = 0; i < plantKeys.length; i++) {
        const plantKey = plantKeys[i];
        const materialKey = materialKeys[i];
        const PurchaseOrderQuantityValue = parseInt(PurchaseOrderQuantityArray[i]);
        const actualArrivalDate = new Date(actualArrivalDates[i]);
        const daysLate = daysTooLate[i];
  
        // Check if the ActualArrivalDateYard is within the specified range
        if (actualArrivalDate >= new Date(mindate) && actualArrivalDate <= new Date(maxdate)) {
          const sumIndex = sums.findIndex(sum => sum.plant === plantKey && sum.material === materialKey);
          if (sumIndex !== -1) {
            sums[sumIndex].sumPurchaseOrderQuantity += PurchaseOrderQuantityValue;
            sums[sumIndex].totalDaysTooLate += daysLate;
            sums[sumIndex].count++;
          } else {
            sums.push({
              plant: plantKey,
              material: materialKey,
              sumPurchaseOrderQuantity: PurchaseOrderQuantityValue,
              totalDaysTooLate: daysLate,
              count: 1
            });
          }
        }
      }
      sums.forEach(sum => {
        sum.averageDaysTooLate = sum.totalDaysTooLate / sum.count;
      });
      return sums;
    }

  </script>
  
    <div>
      <svg width = {width} height = {height}>
        <g>
            <Axis {width} {height} {margin} scale={scaleX} position="bottom"/>
            <Axis {width} {height} {margin} scale={scaleY} position="left"/>
          </g>
          <g>
            <Radiallegend {width} {height} {margin} {radiusScale} />
          </g>
          <g>
            <Labels labelforx={true} {width} {height} {margin}
                    yoffset={-30} xoffset={-170} label={'Distribution center'} />
            <Labels labelfory={true} textanchor={'start'} {width} {height} {margin}
                    yoffset={10} xoffset={10} label={'Average number of days too late'} />
          </g> 
        {#each dataScatterplot as value}
        <circle cx={scaleX(value.plant)} cy={scaleY(value.averageDaysTooLate)}
         r={radiusScale(value.sumPurchaseOrderQuantity)} fill={colours(value.material)}>
         <title>
          Number of purchases: {value.sumPurchaseOrderQuantity}
Average number of days too late: {value.averageDaysTooLate}</title>
         </circle>
         {/each}
      </svg>
    </div>

    <div class="inputs">
        <p>
          I want to see the data of which the actual arrival date ranges<br/>
          from: <br/> <input type="date" bind:value={$mindate}/> <br/>
          until: <br/> <input type="date" bind:value={$maxdate}/>
        </p>
      </div>
      <div class="colourlegend">
        <span class="orange">material 1: Car battery</span>
        <span class="fuchsia">material 2: Home battery</span>
    </div>
    
    
      <style>
        .inputs {
          position: absolute;
          top: 20px;
          right: 340px;
          display: flex;
          flex-direction: column;
        }
        .colourlegend {
          position: absolute;
          top: 490px;
          right: 470px;
          display: flex;
          flex-direction: column;
        }
        .orange {
    color: orange;
}

.fuchsia {
    color: fuchsia;
}

      </style>