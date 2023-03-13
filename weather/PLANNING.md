

# Weather planning


We have 4 things that are visible during weather events:
- `Fog`
- `Rain`
- `CloudShadows` (NYI)
- `WindEffect` (NYI)


The current effects are determined by these three parameters:
```
Wetness:  0 --> 1
Sunniness: 0 --> 1
Cloudiness:  0 --> 1
Windiness: -1 --> 1
```


And here are the calculations for how 
the weather should be determined:
```
Fog  =  +Cloudyness  +Wetness  -abs(Windiness)  -Sunniness/2

CloudShadow  =  +Cloudyness +Sunniness

Rain  =  +Cloudiness  +Raininess  +Wetness  -Sunniness

WindEffect  =  +abs(Windiness)  +Sunniness

SunBeam  =  +Sunniness
```

