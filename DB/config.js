require('dotenv').config()
const sequelize = require("sequelize");
//const params = require("../params.json");

const seq = new sequelize.Sequelize(process.env.LOCAL_DB_NAME, process.env.LOCAL_DB_USERNAME, process.env.LOCAL_DB_PASSWORD, {
    host: process.env.LOCAL_DB_HOST,
    dialect: 'mysql',
});

const testConnection = () => seq.authenticate().then(() => {
    console.log("succes");
}, (err => { console.error(err); }));

module.exports={
    testConnection:testConnection,
    sequelize:seq
}