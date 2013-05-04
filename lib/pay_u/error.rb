module PayU
  class Error < StandardError
    def self.exception(error_code)
      error_code = error_code.to_i
      case
      when error_code < 200
        PayU::InternalError.new(error_code)
      when error_code.in? [200, 201]
        PayU::TransactionError.new(error_code)
      when error_code.in? [501, 508]
        PayU::AuthorizationError.new(error_code)
      when error_code.in? [599, 999]
        PayU::FatalError.new(error_code)
      when error_code < 300 || error_code >= 500
        PayU::ClientError.new(error_code)
      else
        raise StandardError, "Unknown error code: #{error_code}"
    end
    
    def initialize(error_code)
      @error_code = error_code
      @message = ERROR_DESCRIPTIONS[error_code]
    end
  
  end
  
  # Internal errors are irrecoverable problems that most probably are a result of a bug in PayU gem.
  class InternalError < Error
    ERROR_DESCRIPTIONS = {
      100 => 'brak lub błędna wartość parametru pos_id',
      101 => 'brak parametru session_id',
      102 => 'brak parametru ts',
      103 => 'brak lub błędna wartość parametru sig',
      104 => 'brak parametru desc',
      105 => 'brak parametru client_ip',
      106 => 'brak parametru first_name',
      107 => 'brak parametru last_name',
      108 => 'brak parametru street',
      109 => 'brak parametru city',
      110 => 'brak parametru post_code',
      111 => 'brak parametru amount (lub/oraz amount_netto dla usługi SMS)',
      112 => 'błędny numer konta bankowego',
      113 => 'brak parametru email',
      114 => 'brak numeru telefonu'
    }
  end
  
  # PayU system error that may be temporary, you should retry your payment
  class TransactionError < Error
    ERROR_DESCRIPTIONS = {
      200 => 'inny chwilowy błąd',
      201 => 'inny chwilowy błąd bazy danych'
    }
  end
  
  # Errors caused by submitting invalid data or performing invalid operations
  class ClientError < Error
    ERROR_DESCRIPTIONS = {
      202 => 'POS o podanym identyfikatorze jest zablokowany',
      203 => 'niedozwolona wartość pay_type dla danego parametru pos_id',
      204 => 'podana metoda płatności (wartość pay_type) jest chwilowo zablokowana dla danego parametru pos_id, np. przerwa konserwacyjna bramki płatniczej',
      205 => 'kwota transakcji mniejsza od wartości minimalnej',
      206 => 'kwota transakcji większa od wartości maksymalnej',
      207 => 'przekroczona wartość wszystkich transakcji dla jednego klienta w ostatnim przedziale czasowym',
      208 => 'POS działa w wariancie ExpressPayment lecz nie nastąpiła aktywacja tego wariantu współpracy (czekamy na zgodę działu obsługi klienta)',
      209 => 'błędny numer pos_id lub pos_auth_key',
      211 => 'nieprawidłowa waluta transakcji',
      500 => 'transakcja nie istnieje',
      502 => 'transakcja rozpoczęta wcześniej',
      503 => 'autoryzacja do transakcji była już przeprowadzana',
      504 => 'transakcja anulowana wcześniej',
      505 => 'transakcja przekazana do odbioru wcześniej',
      506 => 'transakcja już odebrana',
      507 => 'błąd podczas zwrotu środków do Klienta'
    }
  end
  
  # Fatal PayU errors, contact support
  class FatalError < Error
    ERROR_DESCRIPTIONS = {
      599 => 'błędny stan transakcji, np. nie można uznać transakcji kilka razy lub inny, prosimy o kontakt',
      999 => 'inny błąd krytyczny - prosimy o kontakt'
    }
  end
  
  # User cancelled or payment was not authorized properly, recover this error by asking user to try again
  class AuthorizationError < Error
    ERROR_DESCRIPTIONS = {
      501 => 'brak autoryzacji dla danej transakcji',
      508 => 'Klient zrezygnował z płatności'
    }
  end
end
