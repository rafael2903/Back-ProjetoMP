# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormsController, type: :routing do
  describe 'roteamento' do
    it 'rotas para o método #index' do
      expect(get: '/forms').to route_to('forms#index')
    end

    it 'rotas para o método #show' do
      expect(get: '/forms/1').to route_to('forms#show', id: '1')
    end

    it 'rotas para o método #create' do
      expect(post: '/forms').to route_to('forms#create')
    end

    it 'rotas para o método #update via PUT' do
      expect(put: '/forms/1').to route_to('forms#update', id: '1')
    end

    it 'rotas para o método #update via PATCH' do
      expect(patch: '/forms/1').to route_to('forms#update', id: '1')
    end

    it 'rotas para o método #destroy' do
      expect(delete: '/forms/1').to route_to('forms#destroy', id: '1')
    end
  end
end
