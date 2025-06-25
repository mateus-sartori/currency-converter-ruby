<template>
  <div class="flex flex-center full-height bg-dark q-pa-xl">
    <q-card class="converter-container flat q-pa-xl full-width"  style="background: #1e2329; border: 1px solid #2b3139">
      <h2 class="text-h3 q-mb-lg text-center text-weight-bold" style="color: #f0b90b">
        <q-icon name="history" class="q-mr-sm" />
        Conversion History
      </h2>
      
      <q-table
        flat
        :rows="transactionsList"
        :columns="columns"
        row-key="id"
        :loading="loading"
        :pagination="{ rowsPerPage: 10 }"
        class="full-width"
        :grid="$q.screen.lt.md"
        :filter="filter"
        style="background: #1e2329; color: #eaecef;"
        dark
        dense
      >
        <template v-slot:top-right>
          <q-input
            v-model="filter"
            outlined
            dense
            placeholder="Search..."
            class="q-mb-md"
            style="background: #2b3139; border-color: #474d57"
          >
            <template v-slot:append>
              <q-icon name="search" color="grey" />
            </template>
          </q-input>
        </template>

        <template v-slot:no-data>
          <div class="full-width row flex-center text-grey-8 q-pa-lg">
            <q-icon name="info" class="q-mr-sm" />
            No conversions made yet
          </div>
        </template>

        <template v-slot:body-cell-date="props">
          <q-td :props="props" style="color: #eaecef">
            <div class="text-weight-medium">
              {{ props.value }}
            </div>
          </q-td>
        </template>

        <template v-slot:body-cell-rate="props">
          <q-td :props="props">
            <q-badge color="yellow-8" style="background: #f0b90b; color: #1e2329">
              {{ props.value }}
            </q-badge>
          </q-td>
        </template>

        <template v-slot:item="props">
          <div class="q-pa-xs col-xs-12 col-sm-6 col-md-4">
            <q-card class="full-width" style="background: #2b3139; border: 1px solid #474d57">
              <q-card-section>
                <div class="text-subtitle1 text-weight-bold" style="color: #f0b90b">
                  {{ new Date(props.row.timestamps).toLocaleString('pt-BR') }}
                </div>
                <q-separator class="q-my-sm" style="background: #474d57" />
                <div class="row items-center q-gutter-sm">
                  <div class="col-auto">
                    <q-icon name="currency_exchange" color="yellow-8" style="color: #f0b90b" />
                  </div>
                  <div class="col">
                    <div class="text-caption" style="color: #848e9c">From</div>
                    <div class="text-weight-medium" style="color: #eaecef">
                      {{ props.row.from_value }} {{ props.row.from_currency }}
                    </div>
                  </div>
                  <div class="col-auto">
                    <q-icon name="arrow_forward" color="grey" />
                  </div>
                  <div class="col">
                    <div class="text-caption" style="color: #848e9c">To</div>
                    <div class="text-weight-medium" style="color: #eaecef">
                      {{ props.row.to_value }} {{ props.row.to_currency }}
                    </div>
                  </div>
                </div>
                <q-separator class="q-my-sm" style="background: #474d57" />
                <div class="text-caption" style="color: #848e9c">
                  Rate: {{ (props.row.to_value / props.row.from_value).toFixed(4) }}
                </div>
              </q-card-section>
            </q-card>
          </div>
        </template>
      </q-table>
    </q-card>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted, computed } from 'vue';
import { useQuasar } from 'quasar';
import type { QTableColumn } from 'quasar';
import { useUserStore } from 'src/stores/user-store';
import { useTransactionStore } from 'src/stores/transaction-store';
import { ConverterService } from 'src/services/converter_service';

interface Conversion {
  id: number;
  from_currency: string;
  to_currency: string;
  from_value: string;
  to_value: string;
  timestamps: string;
}

export default defineComponent({
  name: 'ConversionHistoryPage',
  
  setup() {
    const $q = useQuasar();
    const userStore = useUserStore();
    const transactionStore = useTransactionStore();
    const loading = ref(false);
    const filter = ref('');

    const userId = computed(() => userStore.state.id);
    const transactionsList = computed(() => transactionStore.getTransactions);

    const columns: QTableColumn[] = [
      { 
        name: 'date', 
        label: 'Date', 
        field: (row: Conversion) => `${new Date(row.timestamps).toLocaleString('pt-BR')}`,
        align: 'left', 
        sortable: true,
        style: 'color: #eaecef'
      },
      { 
        name: 'from', 
        label: 'From', 
        field: (row: Conversion) => `${row.from_value} ${row.from_currency}`,
        align: 'left',
        style: 'color: #eaecef'
      },
      { 
        name: 'to', 
        label: 'To', 
        field: (row: Conversion) => `${row.to_value} ${row.to_currency}`,
        align: 'left',
        style: 'color: #eaecef'
      },
      { 
        name: 'rate', 
        label: 'Rate', 
        field: (row: Conversion) => (Number(row.to_value) / Number(row.from_value)).toFixed(4),
        align: 'center',
        style: 'color: #eaecef'
      },
      { 
        name: 'result', 
        label: 'Result', 
        field: (row: Conversion) => `${Number(row.to_value).toLocaleString('pt-BR', { style: 'currency', currency: row.to_currency })}`,
        align: 'right',
        style: 'color: #eaecef'
      }
    ];

    const fetchConversionHistory = async () => {
      try {
        if (!userId.value) {
          throw new Error('User not authenticated');
        }

        loading.value = true;
        await ConverterService.fetchConversionHistory(userId.value);
      } catch (error) {
        $q.notify({
          type: 'negative',
          message: error instanceof Error ? error.message : 'Error loading history'
        });
      } finally {
        loading.value = false;
      }
    };

    onMounted(async () => {
      await fetchConversionHistory();
    });

    return {
      transactionsList,
      columns,
      loading,
      filter
    };
  }
});
</script>

<style scoped>
.q-table {
  border-radius: 8px;
}
</style>
