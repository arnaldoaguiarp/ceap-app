require 'csv'

class CsvProcessorService
  def initialize(file_path, state_uf)
    @file_path = file_path
    @state_uf = state_uf.strip.upcase
  end

  def call
    Rails.logger.info "--- INICIANDO PROCESSAMENTO: Arquivo: '#{@file_path}', Estado: '#{@state_uf}' ---"
    
    # Log de verificação do arquivo
    unless File.exist?(@file_path)
      Rails.logger.error "!!!!!! ARQUIVO NÃO ENCONTRADO EM: #{@file_path} !!!!!!"
      return
    end
    
    begin
      row_count = 0
      matches_found = 0

      # Log antes do loop
      Rails.logger.info "-> Prestes a iniciar o loop CSV.foreach..."

      CSV.foreach(@file_path, headers: true, col_sep: ';', encoding: 'ISO-8859-1') do |row|
        row_count += 1
        # Log para cada linha
        Rails.logger.info "Lendo linha ##{row_count}: Estado na planilha é '#{row['sgUF']}'" if row_count <= 5 # Loga apenas as 5 primeiras para não poluir

        if row['sgUF']&.strip&.upcase == @state_uf
          matches_found += 1
          # Lógica de criar deputy e expense
          deputy = Deputy.find_or_create_by!(registration_id: row['ideCadastro']) do |d|
            d.name = row['txNomeParlamentar']
            d.party = row['sgPartido']
            d.state = row['sgUF'].strip.upcase
          end
          deputy.expenses.create!(
            supplier: row['txtFornecedor'],
            net_value: row['vlrLiquido'].to_f,
            issue_date: Date.parse(row['datEmissao']),
            document_url: row['urlDocumento']
          )
        end
      end

      # Log após o loop
      Rails.logger.info "-> Loop CSV.foreach concluído. Total de linhas lidas: #{row_count}. Registros correspondentes ao estado: #{matches_found}."

    rescue => e
      Rails.logger.error "!!!!!! ERRO DURANTE O PROCESSAMENTO DO CSV: #{e.message} !!!!!!"
      Rails.logger.error e.backtrace.join("\n")
    end

    Rails.logger.info "--- PROCESSAMENTO CONCLUÍDO ---"
  end
end