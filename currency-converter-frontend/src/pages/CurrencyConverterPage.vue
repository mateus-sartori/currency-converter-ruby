<template>
  <div class="flex flex-center">
    <div class="converter-container q-pa-md shadow-5 rounded-borders">
      <h2 class="text-h4 q-mb-md text-center text-weight-bold">Conversor de Moedas</h2>

      <div class="row q-gutter-md q-mb-md">
        <!-- Campo de valor -->
        <q-input 
          v-model="amount" 
          type="number" 
          label="Valor" 
          outlined 
          class="col"
          :rules="[val => val > 0 || 'O valor deve ser maior que zero']"
          standout="bg-primary text-white"
          dense
        />

        <!-- Seleção de moeda de origem -->
        <q-select 
          v-model="fromCurrency" 
          :options="currencyOptions" 
          label="De" 
          outlined 
          class="col" 
          emit-value
          map-options
          standout="bg-primary text-white"
          dense
        />

        <!-- Seleção de moeda de destino -->
        <q-select 
          v-model="toCurrency" 
          :options="currencyOptions" 
          label="Para" 
          outlined 
          class="col" 
          emit-value
          map-options
          standout="bg-primary text-white"
          dense
        />
      </div>

      <!-- Botão de conversão -->
      <div class="q-mt-md text-center">
        <q-btn 
          color="primary" 
          label="Converter" 
          @click="convertCurrency" 
          :disable="!isFormValid"
          size="lg"
          rounded
          class="full-width"
        />
      </div>

      <!-- Resultado da conversão -->
      <div v-if="convertedAmount" class="q-mt-lg text-center">
        <q-card class="bg-positive text-white q-pa-md">
          <h3 class="text-h5 q-mb-sm">Resultado da Conversão</h3>
          <div class="text-h4">
            {{ amount.toLocaleString('pt-BR', { style: 'currency', currency: fromCurrency }) }} = 
            {{ convertedAmount.toLocaleString('pt-BR', { style: 'currency', currency: toCurrency }) }}
          </div>
          <div class="text-caption q-mt-sm">
            Taxa de conversão: 1 {{ fromCurrency }} = {{ (convertedAmount / amount).toFixed(4) }} {{ toCurrency }}
          </div>
        </q-card>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed } from 'vue';
import { useQuasar } from 'quasar';
import { ConverterService } from 'src/services/converter_service';

export default defineComponent({
  name: 'CurrencyConverterPage',

  setup() {
    const $q = useQuasar();

    // Estados reativos
    const amount = ref<number>(1);
    const fromCurrency = ref<string>('USD');
    const toCurrency = ref<string>('BRL');
    const convertedAmount = ref<number | null>(null);
    const currencyOptions = ref([
      { label: 'Dólar Americano (USD)', value: 'USD' },
      { label: 'Real Brasileiro (BRL)', value: 'BRL' },
      { label: 'Euro (EUR)', value: 'EUR' },
      { label: 'Libra Esterlina (GBP)', value: 'GBP' },
      { label: 'Iene Japonês (JPY)', value: 'JPY' },
    ]);

    // Computed para validação do formulário
    const isFormValid = computed(() => {
      return amount.value > 0 && fromCurrency.value && toCurrency.value;
    });

    // Função de conversão de moeda
    const convertCurrency = async () => {
      try {
        const result = await ConverterService.convertCurrency(
          1, // user_id fixo por enquanto
          fromCurrency.value,
          toCurrency.value,
          amount.value
        );

        convertedAmount.value = result.to_value;
      } catch {
        $q.notify({
          type: 'negative',
          message: 'Erro ao converter moeda. Tente novamente.'
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
      convertCurrency
    };
  }
});
</script>

<style scoped>
.converter-container {
  max-width: 800px;
  width: 100%;
  background: white;
}

.q-input,
.q-select {
  min-width: 200px;
}

.text-h4 {
  font-size: 2rem;
}

.q-card {
  border-radius: 8px;
}
</style>
