# lhama
Simple Lambda-Calculus

Run with command 'lhama' (see releases) to start the interpreter. Run 'lhama script.lh' to run the file 'script.lh'.
Example usage:
```
> (Lx.x y)
(Lx.x y) => y
> 
> first = Lx.Ly.x
> second = Lx.Ly.y
> var = ((&first &first) &second)
> var2 = (&var &var)
> var3 = (&var2 &var2)
> var4 = (&var3 &var3)
> (&var4 &var4)
((((((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y)) (((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y))) ((((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y)) (((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y)))) (((((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y)) (((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y))) ((((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y)) (((Lx.Ly.x Lx.Ly.x) Lx.Ly.y) ((Lx.Ly.x Lx.Ly.x) Lx.Ly.y))))) => Lx.Ly.x
```
You can download the repository and run make to build yourself, or cou can download the executable from the Releases-section.
