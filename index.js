const express = require('express')
const app = express()

const _port = process.env.port || 3000

app.listen(_port,()=>{
    console.log(`Listening on ${_port}`)
})