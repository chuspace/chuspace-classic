import React, { Component } from 'react'
import Row from 'antd/es/grid/row'
import Col from 'antd/es/grid/col'
import Card from 'antd/es/card'

import Form from 'antd/es/form'
import Input from 'antd/es/input'
import Button from 'antd/es/button'
import Icon from 'antd/es/icon'

import 'antd/lib/style/index.css'
import 'antd/lib/form/style/index.css'
import 'antd/lib/input/style/index.css'
import 'antd/lib/button/style/index.css'
import 'antd/lib/grid/style/index.css'
import 'antd/lib/card/style/index.css'
import styles from './styles'

class HorizontalLoginForm extends Component {
  render () {
    return (
      <Row
        type='flex'
        justify='space-around'
        align='middle'
        className={styles.centering}
      >
        <Col span={6}>
          <Card title='Login'>
            <Form className='login-form' onSubmit={this.handleSubmit}>
              <Form.Item>
                <Input
                  prefix={
                    <Icon type='user' style={{ color: 'rgba(0,0,0,.25)' }} />
                  }
                  placeholder='Username'
                />
              </Form.Item>
              <Form.Item>
                <Input
                  prefix={
                    <Icon type='lock' style={{ color: 'rgba(0,0,0,.25)' }} />
                  }
                  type='password'
                  placeholder='Password'
                />
              </Form.Item>
              <Form.Item>
                <Button type='primary' htmlType='submit'>
                  Log in
                </Button>
              </Form.Item>
            </Form>
          </Card>
        </Col>
      </Row>
    )
  }
}

const WrappedForm = Form.create({})(HorizontalLoginForm)
console.log(WrappedForm)
export default HorizontalLoginForm
