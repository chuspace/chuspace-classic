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

@Form.create()
class SignupForm extends Component {
  name = 'Signup'

  render () {
    return (
      <Row
        type='flex'
        justify='space-around'
        align='middle'
        className={styles.centering}
      >
        <Col span={10}>
          <Card title='Signup'>
            <Form className='signup-form' onSubmit={this.handleSubmit}>
              <Row type='flex' justify='space-between'>
                <Col span={11}>
                  <Form.Item>
                    <Input
                      prefix={
                        <Icon
                          type='user'
                          style={{ color: 'rgba(0,0,0,.25)' }}
                        />
                      }
                      placeholder='First name'
                    />
                  </Form.Item>
                </Col>
                <Col span={11}>
                  <Form.Item>
                    <Input
                      prefix={
                        <Icon
                          type='user'
                          style={{ color: 'rgba(0,0,0,.25)' }}
                        />
                      }
                      placeholder='Last Name'
                    />
                  </Form.Item>
                </Col>
                <Col span={11}>
                  <Form.Item>
                    <Input
                      prefix={
                        <Icon
                          type='user'
                          style={{ color: 'rgba(0,0,0,.25)' }}
                        />
                      }
                      placeholder='Email'
                    />
                  </Form.Item>
                </Col>
                <Col span={11}>
                  <Form.Item>
                    <Input
                      prefix={
                        <Icon
                          type='user'
                          style={{ color: 'rgba(0,0,0,.25)' }}
                        />
                      }
                      placeholder='Company'
                    />
                  </Form.Item>
                </Col>
                <Col span={11}>
                  <Form.Item>
                    <Input
                      prefix={
                        <Icon
                          type='user'
                          style={{ color: 'rgba(0,0,0,.25)' }}
                        />
                      }
                      placeholder='Username'
                    />
                  </Form.Item>
                </Col>
                <Col span={11}>
                  <Form.Item>
                    <Input
                      prefix={
                        <Icon
                          type='lock'
                          style={{ color: 'rgba(0,0,0,.25)' }}
                        />
                      }
                      type='password'
                      placeholder='Password'
                    />
                  </Form.Item>
                </Col>
              </Row>
              <Form.Item>
                <Button type='primary' htmlType='submit'>
                  Signup
                </Button>
              </Form.Item>
            </Form>
          </Card>
        </Col>
      </Row>
    )
  }
}

export default SignupForm
