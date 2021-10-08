
const sequelize = require("sequelize");
const config = require("../config");


const Shop = config.sequelize.define('shop', {
    id: {
        type: sequelize.DataTypes.INTEGER,
        primaryKey: true,
        unique: true,
    },
    name: {
        type: sequelize.DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    address: {
        type: sequelize.DataTypes.STRING,
        allowNull: true,
        unique: false
    },
}, {
    timestamps: false
});
module.exports=Shop
