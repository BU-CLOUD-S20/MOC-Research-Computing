### Bugs
From the log of `sid_worker`
```
"sid_app":"undefined-88a049f0-52d1-11ea-8c65-f3b31f82d54b"
```
The term `undefined` caused by Line 19 in `/server/config/models/jobs.js`:
```
'sid_app': `${it.jobType}-${it.jobId}`
```
where `jobType` is not defined in passed in `it`. You probably mean `it.type`. If you set `jobType` in `it`, Joi validation fails:
```
"message":"\"jobType\" is not allowed"
```