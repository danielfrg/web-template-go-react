import * as React from "react";
import axios, { AxiosRequestConfig, AxiosPromise } from 'axios';

interface FormProps { 
    title: string
}

interface FormState {
    num1: number;
    num2: number;
    value: number;
}

export class Form extends React.Component<FormProps, FormState> {
    constructor(props: FormProps) {
        super(props);
        this.state = this.getInitState();
        this.handleClick = this.handleClick.bind(this);
    }

    private getInitState(): FormState { 
        return {
            num1: 3,
            num2: 7,
            value: 0,
        }
    }

    private updateNumbersValue(evt: React.ChangeEvent<HTMLInputElement>) {
        var target = evt.target.id;
        var value = parseInt(evt.target.value)

        if (target == "num1") {
            this.setState({
                num1: value
            });
        }
        else if (target == "num2") {
            this.setState({
                num2: value
            });
        }
      }
    
      private handleClick() {
        console.log(this.state.num1 + ' ' + this.state.num2)
        axios.get('/api/v1/add?a=' + this.state.num1 +'&b=' + this.state.num2)
            .then(response => this.setState({value: response.data }))
    }

    render() {
        return (
            <div className="row">
                <div className="col-md-4 order-md-2 mb-4">
                    <h4 className="mb-3">Result:</h4>
                    <ul className="list-group mb-3">
                        <li className="list-group-item d-flex justify-content-between">
                            <span>Total</span>
                            <strong>{this.state.value}</strong>
                        </li>
                    </ul>
                </div>
                
                <div className="col-md-8 order-md-1">
                    <form className="needs-validation" noValidate>
                        <h4 className="mb-3">Your numbers:</h4>
                        <div className="mb-3">
                            <label htmlFor="num1">Number 1 <span className="text-muted">(a number)</span></label>
                            <input type="number" className="form-control" id="num1" value={this.state.num1} onChange={evt => this.updateNumbersValue(evt)} />
                        </div>

                        <div className="mb-3">
                            <label htmlFor="num2">Number 2 <span className="text-muted">(a number)</span></label>
                            <input type="text" className="form-control" id="num2" value={this.state.num2} onChange={evt => this.updateNumbersValue(evt)} />
                        </div>

                        <hr className="mb-4"/>
                        <button type="button" className="btn btn-primary btn-lg btn-block" onClick={this.handleClick}>Add numbers!</button>
                    </form>
                </div>  
            </div>
        );
    }
}
