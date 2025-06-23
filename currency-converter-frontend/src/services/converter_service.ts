import createAxiosInstance from 'src/helpers/axios_instance';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api/v1/';
const api = createAxiosInstance(API_BASE_URL);

interface ConversionResult {
  from_currency: string;
  to_currency: string;
  from_value: number;
  to_value: number;
  rate: number;
}

/**
 * Serviço para conversão de moedas
 */
export const ConverterService = {
  /**
   * Realiza a conversão de moedas
   * @param userId - ID do usuário
   * @param fromCurrency - Moeda de origem
   * @param toCurrency - Moeda de destino
   * @param amount - Valor a ser convertido
   * @returns Promise com o resultado da conversão
   */
  async convertCurrency(
    userId: number,
    fromCurrency: string,
    toCurrency: string,
    amount: number
  ): Promise<ConversionResult> {
    try {
      const response = await api.post('/transactions', {
        transaction: {
          user_id: userId,
          from_value: amount,
          from_currency: fromCurrency,
          to_currency: toCurrency
        }
      });

      return {
        from_currency: response.data.from_currency,
        to_currency: response.data.to_currency,
        from_value: response.data.from_value,
        to_value: response.data.to_value,
        rate: response.data.rate
      };
    } catch {
      throw new Error('Erro ao converter moeda. Tente novamente.');
    }
  }
};
