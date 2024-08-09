# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Especifica a pasta raiz onde os arquivos JSON do Swagger são gerados
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define um ou mais documentos Swagger e fornece metadados globais para cada um
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1',
        description: 'Esta é a primeira versão da API.'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Servidor Local'
        }
      ],
      components: {
        securitySchemes: {
          BearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  # Especifica o formato do arquivo Swagger gerado ao executar 'rswag:specs:swaggerize'
  config.swagger_format = :yaml

  # Habilita a validação estrita do schema do OpenAPI
  config.openapi_strict_schema_validation = true
end

