function authCheck(req,res,next){
    const token=req.headers["authorization"]

    if(token==="szup3rbizt0ns4g0s"){
        next()
    }
    else{
        res.status(401).json({"error":"Wrong API key"})
    }
}

module.exports = {authCheck}