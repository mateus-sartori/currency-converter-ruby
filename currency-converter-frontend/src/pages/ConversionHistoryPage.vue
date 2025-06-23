<template>
  <div class="flex flex-center">
    <div class="history-container q-pa-md">
      <h2 class="text-h4 q-mb-md">Histórico de Conversões</h2>
      
      <q-table
        flat
        bordered
        :rows="conversionHistory"
        :columns="columns"
        row-key="id"
        :loading="loading"
        class="full-width"
      >
        <template v-slot:no-data>
          <div class="full-width row flex-center text-grey-8">
            Nenhuma conversão realizada ainda
          </div>
        </template>
      </q-table>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useQuasar } from 'quasar';
import createAxiosInstance from 'src/helpers/axios_instance';
import type { QTableColumn } from 'quasar';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000";
const web = createAxiosInstance(API_BASE_URL);

interface Conversion {
  id: string;
  fromCurrency: string;
  toCurrency: string;
  fromValue: number;
  toValue: number;
  createdAt: string;
}

export default defineComponent({
  name: 'ConversionHistoryPage',
  
  setup() {
    const $q = useQuasar();
    const conversionHistory = ref([]);
    const loading = ref(false);

    const columns: QTableColumn[] = [
      { name: 'date', label: 'Data', field: 'date', align: 'left', sortable: true },
      { name: 'from', label: 'De', field: 'from', align: 'left' },
      { name: 'to', label: 'Para', field: 'to', align: 'left' },
      { name: 'amount', label: 'Valor', field: 'amount', align: 'right' },
      { name: 'result', label: 'Resultado', field: 'result', align: 'right' }
    ];

    const fetchConversionHistory = async () => {
      try {
        loading.value = true;
        const response = await web.get('/conversions');
        conversionHistory.value = response.data.map((conversion: Conversion) => ({
          ...conversion,
          date: new Date(conversion.createdAt).toLocaleString()
        }));
      } catch  {
        $q.notify({
          type: 'negative',
          message: 'Erro ao carregar histórico de conversões'
        });
      } finally {
        loading.value = false;
      }
    };

    onMounted(async () => {
      await fetchConversionHistory();
    });

    return {
      conversionHistory,
      columns,
      loading
    };
  }
});
</script>

<style scoped>
.history-container {
  max-width: 1200px;
  width: 100%;
}
</style>
