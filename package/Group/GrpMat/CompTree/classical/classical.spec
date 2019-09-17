classical.m
omega3.m
attributes.m

presentation
{
	+presentation.spec
}

rewriting
{
    +spec
}

recognition
{
	standard.m
	basics.m
        section.m
	conjugate.m
        is-classical.m
        derived.m
        order.m
        Forms {
           #correct_form.m
           correct_orth.m
        }
        black
        {
             odd
             {
               +spec 
             }
             even
             {
               +spec
             }
 
        }
        modules
        {  
           +modules.spec
        }
        natural
        {
           even
           {
             +StdGensEvenSX.spec
           }
           odd {
         	sl
         	{
			gen.m
			sl.m
         	}
         	sp
         	{
			sp.m
         	}
         	su
         	{
			su.m
         	}
         	orthogonal
         	{
			dp.m
			involution.m
			so-5.m
			so.m
			sominus-6.m
			sominus.m
			sominus-special.m
			soplus.m
			soplus-special.m
			so-product.m
			so-special.m
         	}
              }
        }
}
