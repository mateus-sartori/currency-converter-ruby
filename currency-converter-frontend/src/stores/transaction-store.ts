import { defineStore } from 'pinia';
import type { DefineStoreOptions } from 'pinia';
import { reactive, computed } from 'vue';

type CustomStoreOptions = DefineStoreOptions<string, any, any, any> & {
  persist?: boolean;
};

interface TransactionState {
  id: number;
  from_currency: string;
  to_currency: string;
  from_value: string;
  to_value: string;
  timestamps: string;
}

export const useTransactionStore = defineStore('transaction', () => {
  const state = reactive<TransactionState>({
    id: 0,
    from_currency: '',
    to_currency: '',
    from_value: '',
    to_value: '',
    timestamps: ''
  });

  const transactionsList = reactive<TransactionState[]>([]);

  const transactions = computed(() => ({
    id: state.id,
    from_currency: state.from_currency,
    to_currency: state.to_currency,
    from_value: state.from_value,
    to_value: state.to_value,
    timestamps: state.timestamps
  }));

  const getTransactions = computed(() => 
    transactionsList.slice().sort((a, b) => 
      new Date(b.timestamps).getTime() - new Date(a.timestamps).getTime()
    )
  );

  function clearTransactions() {
    transactionsList.splice(0, transactionsList.length);
  }

  function addTransaction(transaction: TransactionState) {
    transactionsList.unshift(transaction);

  }
  
  function setTransactions(transactions: TransactionState[]) {
    clearTransactions();
    transactions.forEach(transaction => {
      transactionsList.push({
        id: transaction.id,
        from_currency: transaction.from_currency,
        to_currency: transaction.to_currency,
        from_value: transaction.from_value,
        to_value: transaction.to_value,
        timestamps: transaction.timestamps
      });
    });
  }

  return {
    state,
    
    transactions,
    getTransactions,
    
    addTransaction,
    setTransactions,
    clearTransactions
  }
}, {
  persist: true,
} as CustomStoreOptions);