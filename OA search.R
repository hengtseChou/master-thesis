Ln=function(N,m,s,w){# the lower bound of J_2(d) in Lemma 1
  (sum(N*w/s)^2+N^2*sum((s-1)*(w/s))-N*sum(w)^2)/2
}

delta=function(d){
  d=cbind(d)#in case d consists of only one column
  r=nrow(d);p=ncol(d)
  s=apply(d,2,max)+1
  ans=matrix(0,r,r)
  for(i in 1:(r-1)){
    for(j in (i+1):r){
      ans[i,j]=ans[j,i]=sum((d[i,]==d[j,])*s)
    }
  }
  return(ans)#note: the diagonal elements are zero for reasons
}
J2=function(d){
  sum(delta(d)^2)/2
}

#N=12, s=2
lb=rep(NA,11)
for(i in 1:length(lb)){
  lb[i]=Ln(12,i,rep(2,i),rep(2,i))
}
lb

N=12
d=matrix(0,N,2)
d[,1]=rep(0:1,each=N/2)
d[,2]=rep(0:1,each=N/4,2)
J2.tmp=J2(d)
dd=delta(d)
t1=0
make_new_column=T
while(ncol(d)<11){
  cc=sample(d[,1]) #random balanced column to add in
  dc=delta(cc)
  if (make_new_column) {J2.tmp=J2.tmp+sum(dd*dc)+0.5*N*2^2*(N/2-1); make_new_column=F}
  if(J2.tmp==lb[ncol(d)+1]){
    d=cbind(d,cc);dd=delta(d);t1=0;make_new_column=T;next
  }else{
    red=0;aa=bb=0
    for(a in which(cc==0)){
      for(b in which(cc==1)){
        ab=c(a,b)
        red.new=sum((dd[-ab,ab[1]]-dd[-ab,ab[2]])*(dc[-ab,ab[1]]-dc[-ab,ab[2]])) #equation (5)
        if(red.new>red){aa=ab[1];bb=ab[2];red=red.new}
      }
    }
    cc[c(aa,bb)]=cc[c(bb,aa)]
    J2.tmp=J2.tmp-2*red
    if(J2.tmp==lb[ncol(d)+1]){d=cbind(d,cc);dd=delta(d);t1=0;make_new_column=T;next}
    if(t1==200){d=cbind(d,cc);dd=delta(d);t1=0;print(ncol(d));make_new_column=T;next}
    t1=t1+1
  }
}
d
colnames(d)=1:11
t(2*d-1)%*%(2*d-1)