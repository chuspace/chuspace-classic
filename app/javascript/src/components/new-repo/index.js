import React, { Component } from 'react'

import axiosClient from 'helpers/axios-client'
import to from 'helpers/await-to'

import Input from 'components/input'
import Textarea from 'components/textarea'
import Select from 'components/select'
import Button from 'components/button'

export default class NewRepo extends Component {
  static Form = {
    organization: undefined,
    name: undefined,
    description: undefined
  }

  formNode: ?HTMLFormElement

  state = {
    showForm: false,
    submitting: false,
    success: false,
    form: NewRepo.Form,
    errors: NewRepo.Form
  }

  handleInputChange = (e: SyntheticEvent<HTMLInputElement>) => {
    const form = { ...this.state.form }
    form[e.currentTarget.name] = e.currentTarget.value
    this.setState({ form, errors: NewRepo.Form })
  }

  handleSubmit = async (e: SyntheticEvent<HTMLFormElement>) => {
    e.preventDefault()
    const [error] = await to(
      axiosClient.post(this.props.repos_path, { ...this.state.form })
    )

    if (error) {
      this.setState({
        errors: error.response.data.errors
      })
    } else {
      /* $FlowFixMe */
      this.formNode.reset()
      this.setState({ form: NewRepo.Form, success: true }, () =>
        setTimeout(() => (window.location.href = '/'), 5000)
      )
    }
  }

  renderForm = () => (
    <form
      className='form measure center'
      onSubmit={this.handleSubmit}
      ref={node => (this.formNode = node)}
    >
      <Select
        autoComplete='off'
        label='Owner'
        onChange={this.handleInputChange}
        name='organization'
        error={this.state.errors.organization}
        autoFocus
        required
      >
        <option key='-1' value='' disabled>
          Choose another owner
        </option>
        {this.props.owners.map((owner, index) => (
          <option key={index} value={owner}>
            {owner}
          </option>
        ))}
      </Select>
      <Input
        autoComplete='off'
        label='Repo name'
        onChange={this.handleInputChange}
        error={this.state.errors.name}
        name='name'
        value={this.state.form.repo}
        placeholder='Repo name'
        required
      />
      <Textarea
        onChange={this.handleInputChange}
        name='description'
        label='Repo description'
        rows={2}
        error={this.state.errors.description}
        value={this.state.form.description}
        placeholder='Description (optional)'
      />
      <Button
        title='Submit'
        disabled={this.state.submitting}
        className='center bg-black white bn mt3'
      />
    </form>
  )

  renderSuccess = () => (
    <div className='pa3 bg-light-yellow'>
      <p className='intro f5 lh-copy'>
        Awesome! You are all set to post articles on Chuspace.
      </p>
    </div>
  )

  render () {
    return (
      <div className='vh-75 dt center'>
        <div className='dtc v-mid'>
          <div className='brand-bg-green pa3 bn br2 shadow-3 ph4'>
            <div className='header bb b--light-gray mb4'>
              <h1 className='f3 lh-title mv2'>Create a new repository</h1>
              <p className='f6 lh-copy mt1 mb2'>
                A repository contains all the files for your project, including
                the revision history.
              </p>
            </div>
            {this.state.success ? this.renderSuccess() : this.renderForm()}
          </div>
        </div>
      </div>
    )
  }
}
