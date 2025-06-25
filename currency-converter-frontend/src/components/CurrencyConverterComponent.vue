<template>
  <div class="flex flex-center full-height bg-dark">
    <q-card class="converter-container flat q-pa-xl" style="background: #1e2329; border: 1px solid #2b3139">
      <h2 class="text-h3 q-mb-lg text-center text-weight-bold" style="color: #f0b90b">
        <q-icon name="currency_exchange" class="q-mr-sm" />
        Currency Converter
      </h2>

      <div class="row q-gutter-md items-center q-mb-lg">
        <q-input 
          v-model="amount" 
          type="number" 
          label="Amount" 
          outlined 
          class="col" 
          standout="bg-dark text-white"
          dense 
          style="background: #2b3139; border-color: #474d57"
          dark
        />

        <q-select 
          v-model="fromCurrency" 
          :options="currencyOptions" 
          label="From" 
          outlined 
          class="col" 
          emit-value
          map-options 
          standout="bg-dark text-white"
          dense
          style="background: #2b3139; border-color: #474d57"
          dark
        />

        <div class="col-auto flex flex-center">
          <q-btn 
            round 
            color="yellow-8" 
            size="sm" 
            icon="swap_horiz" 
            @click="swapCurrencies" 
            class="q-mx-sm" 
            style="background: #f0b90b"
          />
        </div>

        <q-select 
          v-model="toCurrency" 
          :options="currencyOptions" 
          label="To" 
          outlined 
          class="col" 
          emit-value
          map-options 
          standout="bg-dark text-white"
          dense
          style="background: #2b3139; border-color: #474d57"
          dark
        />
      </div>

      <div class="q-mt-lg text-center">
        <q-btn 
          color="yellow-8" 
          label="Convert" 
          @click="convertCurrency" 
          :disable="!isFormValid" 
          size="lg" 
          rounded
          class="full-width q-mb-lg" 
          icon="calculate" 
          style="background: #f0b90b; color: #1e2329"
        />
      </div>

      <div v-if="convertedAmount" class="q-mt-lg">
        <q-card style="background: #2b3139; border: 1px solid #474d57">
          <q-card-section>
            <h3 class="text-h5 q-mb-sm text-weight-bold" style="color: #f0b90b">
              <q-icon name="check_circle" class="q-mr-sm" />
              Conversion Result
            </h3>
            <div class="text-h4 q-mb-sm" style="color: #eaecef">
              {{ convertedAmount.from_value.toLocaleString('en-US', { style: 'currency', currency: fromCurrency }) }} =
              {{ convertedAmount.to_value.toLocaleString('en-US', { style: 'currency', currency: toCurrency }) }}
            </div>
            <div class="text-caption" style="color: #848e9c">
              <q-icon name="trending_up" class="q-mr-xs" />
              Conversion rate {{ fromCurrency }} = {{ convertedAmount.rate.toFixed(4) }} {{ toCurrency }}
            </div>
          </q-card-section>
        </q-card>
      </div>
    </q-card>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed } from 'vue';
import { useQuasar } from 'quasar';
import { ConverterService } from 'src/services/converter_service';
import { useUserStore } from 'src/stores/user-store';

interface ConversionResult {
  from_value: number;
  to_value: number;
  rate: number;
}

export default defineComponent({
  name: 'CurrencyConverterPage',

  setup() {
    const $q = useQuasar();
    const userStore = useUserStore();
    const userId = computed(() => userStore.state.id);

    // Reactive states
    const amount = ref<number>(1);
    const fromCurrency = ref<string>('USD');
    const toCurrency = ref<string>('BRL');
    const convertedAmount = ref<ConversionResult | null>(null);
    const currencyOptions = ref([
      { label: 'US Dollar (USD)', value: 'USD' },
      { label: 'Brazilian Real (BRL)', value: 'BRL' },
      { label: 'Euro (EUR)', value: 'EUR' },
      { label: 'British Pound (GBP)', value: 'GBP' },
      { label: 'Japanese Yen (JPY)', value: 'JPY' },
    ]);

    const isFormValid = computed(() => {
      return amount.value > 0 && fromCurrency.value && toCurrency.value;
    });

    const swapCurrencies = () => {
      const temp = fromCurrency.value;
      fromCurrency.value = toCurrency.value;
      toCurrency.value = temp;

      convertedAmount.value = null;
    };

    const convertCurrency = async () => {
      try {
        if (!userId.value) throw new Error('User not authenticated');

        const result = await ConverterService.convertCurrency(
          userId.value,
          fromCurrency.value,
          toCurrency.value,
          amount.value
        );

        convertedAmount.value = {
          from_value: amount.value,
          to_value: result.to_value,
          rate: result.to_value / amount.value
        };
      } catch (error: unknown) {
        $q.notify({
          type: 'negative',
          message: error instanceof Error ? error.message : String(error),
        });
        convertedAmount.value = null;
      }
    };

    return {
      amount,
      fromCurrency,
      toCurrency,
      convertedAmount,
      currencyOptions,
      isFormValid,
      convertCurrency,
      swapCurrencies
    };
  }
});
</script>

<style scoped>
.converter-container {
  width: 100%;
  max-width: 800px;
  margin: 2rem;
}

.full-height {
  min-height: 100vh;
}

.q-input,
.q-select {
  min-width: 200px;
}

.text-h3 {
  font-size: 2.5rem;
}

.q-card {
  border-radius: 8px;
}

.q-btn--round {
  transform: scale(1.2);
}
</style>