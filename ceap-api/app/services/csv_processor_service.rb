require 'csv'

class CsvProcessorService
  def initialize(csv_content, state_uf)
    @csv_content = csv_content
    @state_uf = state_uf.strip.upcase
  end

  def call
    Rails.logger.info "Iniciando limpeza de dados antigos para o estado: #{@state_uf}..."

    deputies_in_state = Deputy.where(state: @state_uf)
    deputies_in_state.destroy_all
    Rails.logger.info "Limpeza de dados antigos para #{@state_uf} concluída."

    Rails.logger.info "Iniciando processamento para Estado '#{@state_uf}'"
    begin
      row_count = 0
      matches_found = 0

      # Log antes do loop
      Rails.logger.info '-> Prestes a iniciar o loop CSV.parse...'

      CSV.parse(@csv_content, headers: true, col_sep: ';', encoding: 'UTF-8', liberal_parsing: true, header_converters: :symbol) do |row|
        row_count += 1
        Rails.logger.info "Lendo linha ##{row_count}" if row_count <= 6 # Loga as 6 primeiras

        next if row.to_h.values.all?(&:blank?)
        next if row[:sguf] == 'NA' || row[:sguf]&.strip&.upcase != @state_uf
        next if row[:txnomeparlamentar].blank? || row[:idecadastro].blank? || row[:datemissao].blank?

        matches_found += 1

        deputy = Deputy.find_or_create_by!(registration_id: row[:idecadastro]) do |d|
          d.name = row[:txnomeparlamentar]
          d.party = row[:sgpartido].presence || "NÃO INFORMADO"
          d.state = row[:sguf].strip.upcase
        end

        deputy.expenses.create!(
          supplier: row[:txtfornecedor],
          net_value: row[:vlrliquido].to_f,
          issue_date: Date.parse(row[:datemissao]),
          document_url: row[:urldocumento].presence || ''
        )
      end

      Rails.logger.info "-> Processamento concluído. Total de linhas lidas: #{row_count}. Registros para '#{@state_uf}': #{matches_found}."
    rescue Date::Error => e
      Rails.logger.error "!!!!!! ERRO DE PARSE DE DATA: #{e.message}. Verifique o formato das datas no CSV. !!!!!!"
    rescue => e
      Rails.logger.error "!!!!!! ERRO DURANTE O PROCESSAMENTO DO CSV: #{e.message} !!!!!!"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
