
const sequelize = require("sequelize");
const config = require("../config");


const Coupon = config.sequelize.define('coupon', {
    id: {
        type: sequelize.DataTypes.INTEGER,
        primaryKey: true,
        unique: true,
        autoIncrement:true
    },
    name: {
        type: sequelize.DataTypes.STRING,
        allowNull: false,
        unique: false
    },
    description: {
        type: sequelize.DataTypes.STRING,
        allowNull: false,
        unique: false
    },
    bargain:{
        type:sequelize.DataTypes.INTEGER,
        allowNull:true,
        unique:false
    },
    type:{
        type:sequelize.DataTypes.STRING,            //type: type1, type2, type3, végösszegből enged el konkrét összeget, %-ot enged el stb...
        allowNull:false,
        unique:false
    },
    endDate: {
        type: sequelize.DataTypes.DATE,
        allowNull: false,
        unique: false
    },
    shopId:{
        type:sequelize.DataTypes.INTEGER,
        allowNull:false,
        unique:false
    }
}, {
    timestamps: false
});

module.exports=Coupon
