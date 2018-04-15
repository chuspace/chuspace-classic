import axios from 'axios'
import Rails from 'rails-ujs'

export default axios.create({
  timeout: 10000,
  headers: {
    'X-CSRF-Token': Rails.csrfToken()
  }
})
