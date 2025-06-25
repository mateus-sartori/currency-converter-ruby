<template>
  <q-page >
    <div class="row ">
      <div class="col-12 col-md-5">
        <currency-converter-component />
      </div>
      <div class="col-12 col-md-7">
        <conversion-history-component />
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import CurrencyConverterComponent from 'components/CurrencyConverterComponent.vue';
import ConversionHistoryComponent from 'components/ConversionHistoryComponent.vue';
</script>
