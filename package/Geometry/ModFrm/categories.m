freeze;
 
/****-*-magma-* EXPORT DATE: 2004-03-08 ************************************
                                                                            
                     MODFORM: Modular Forms in MAGMA
 
                              William A. Stein        
                         
   FILE: categories.m

   04/06/03: Added attribute t2_eigenvector.

   $Header: /home/was/magma/packages/ModFrm/code/RCS/categories.m,v 1.7 2002/08/26 22:26:59 was Exp $

   $Log: categories.m,v $
   Revision 1.7  2002/08/26 22:26:59  was
   Really changed modular_symbols to mf_modular_symbols.

   Revision 1.6  2002/08/26 21:10:26  was
   changed modular_symbols to mf_modular_symbols

   Revision 1.5  2002/04/18 23:15:49  was
   added atkin_operator

   Revision 1.4  2002/04/13 07:26:27  was
   Added type_param for things like the p for p-newforms.

   Revision 1.3  2001/05/30 18:53:55  was
   Created.

   Revision 1.2  2001/05/16 03:54:52  was
   Initial code.

   Revision 1.1  2001/05/16 03:50:49  was
   Initial revision

      
 ***************************************************************************/

declare type ModFrm [ModFrmElt];
declare type ModFrmElt;

declare attributes ModFrm:
        ambient_space,  

        base_ring,
 
        base_extend_map,   // save map if created by BaseExtend

        associated_space_over_z,  // what this is the tensor product of.

        type,  // "ring", "ambient", "cusp", "eis", "new", 
               // "cusp_new", "eis_new", "cusp_newform", "eis_newform", 
               // "full_half_int", "cusp_half_int"
               // Looks like "ambient" got changed to "full" ??   --- Steve

        type_param,   // type parameter: 0 for every type except new when it can be, e.g., p
                      // for the p-new forms.

        // subspaces (only set by ambient space)
        cusp, eis, new, cusp_new, eis_new,
        
        // if this space was made to support a newform, the 
        // the ambient space it was made from is pointed to here.
        made_from_newform,

        is_cuspidal,
        cuspidal_subspace,

        is_new,
        new_subspace,

        is_eisenstein, 
        eisenstein_subspace,

   // the primitive eisenstein series and their twists over Q(zeta_n)
        eisenstein_series,

        dimension,      

   // the character(s) of the space; takes values in base_ring
   // (actually that's not the case ... 
   //  eg for ModularForms(Gamma1(N)) the base_ring is Z 
   //     but the character values are in Q(zeta_N) 
   //                                 --- Steve)
        dirichlet_character, 

   // true if this is a space of modular forms for Gamma_1(N)
        is_gamma1,
  
   // true if this is a space of modular forms for Gamma_0(N)
        is_gamma0,

   // true if this is a space of modular forms of gamma type
        is_gamma_type, 
  
        weight,         

   // the level of this space of modular forms. 
        level,

   // the level subgroup of this spaceof modular forms
        level_subgroup,

   // corresponding space(s) of modular symbols
        mf_modular_symbols,

   // The newforms in M.
	newforms,
 
   // order the newforms; this space of modular forms is the
   // parent of the which_newform-th newform.
        which_newform,

   // The basis of ModFrmElt's
        basis,
 
   // Basis of q-expansions for the full space 
   // This is a pair <prec, [qexps]>
       q_expansion_basis,

   // Hecke polynomials computed so far. 
       hecke_polynomial,

       t2_eigenvector, // used in computing hecke polynomials quickly in some cases.

   // Hecke operators computed so far.
       hecke_operator,

   // Atkin-Lehner operators computed so far.
       atkin_operator,

       q_name,   // used in "q-expansions".
       default_precision,

       approx_precision_bound,  // <= Sturm bound
       precision_bound,         // <= exact precision bound

       generated_by_auxiliary,  // list of tuples, providing a recipe for the q-expansion basis
                                // (explained in qexpansion_basis_using_auxiliary)

       wt_half_data,  // a sequence of tuples <psi,t> designating theta series

     //wt1_dihedral_subspace,   // similar structure to eisenstein_subspace 
       wt1_dihedral_forms,      // and eisenstein_series 

       is_wt1_dihedral,         // this attached to the cusp subspace in weight 1 iff the cusp subspace has been computed,
                                // and is true iff the cusp space is generated by the dihedral forms
       wt1_auxil_modsyms,       // used when dihedrals don't give the whole cusp space 
                                // (see BasisOfWeightOneCuspForms in q-expansions.m for details)

       other_levels             // list of tuples <d, ModularSymbols(M,d) > for d|N, d<N 
       ;
       

declare attributes ModFrmElt:
        degree,

   // representation of this element as a vector in the parent space
        element,          

   // true if and only if this form is a newform.
        is_newform,       
 
        nebentype,

   // this element is the eigenform qEigenform(modular_symbols, ..).
        mf_modular_symbols,  

   // the space of modular forms that contains this element.
        parent,           

   // known q-expansion of this element.
        q_expansion,      

   // Used by MoveIntoPowerSeriesRingOverANumberField after recomputing 
   // q_expansion
        number_field_coercion_map,
        cyclotomic_embedding_map,

        weight,

   // which Galois conjugate this newform is
        which_conjugate,   
        first_conjugate,

   // various maps from the coefficient field
        modp_reductions,
        padic_embeddings,
        complex_embeddings,

   // eisenstein series coming from psi, chi
        eisenstein,

   // data describing wt 1 eigenform attached to dihedral rep (see relevant functions)
        wt1_dihedral_data,
 
   // associated elliptic curve
        elliptic_curve,
 
   // q-expansion "gadget", i.e., a function that gives q-expansions
        q_expansion_gadget,
 
   // theta-series data
   // This is a sequence of tuples <L::Lat, c::RngElt> such that 
   // the form equals the sum of theta series c*Theta_L where 
   // Theta_L := Sum_{v in L} q^(v.v) (as returned by ThetaSeries with no varargs).
   // The lattices L MUST BE INTEGRAL, and c should be in the base ring of the parent.
        theta_data,
   
   // TO DO: assign theta_data for sums and multiples of forms that have theta_data  

   // q-expansion from *,-,+, scalar:
   // created_from := <op, g, h>, 
   // where op is "*", "-", "+", or "scalar", and g and h are modular forms,
   // except g is a scalar when op is "scalar", 
   // NOTE: this attribute should only be set if its clear that
   //       circular references won't be created!
        created_from,

   // Stores the ValueAtCusp's for an EisensteinSeries at non-infinite cusps A/B
   // as a list of tuples <A/B, value>
       values_at_cusps 
       ;

     

function CopyOfModFrm(M)
   error "Not written";
end function;

function CopyOfModFrmElt(f)
   assert Type(f) eq ModFrmElt;
   g := New(ModFrmElt);
   if assigned f`degree then
      g`degree := f`degree;
   end if;
   if assigned f`element then
      g`element := f`element ;
   end if;
   if assigned f`is_newform then
      g`is_newform := f`is_newform ;
   end if;
   if assigned f`mf_modular_symbols then
      g`mf_modular_symbols := f`mf_modular_symbols ;
   end if;
   if assigned f`parent then
      g`parent := f`parent ;
   end if;
   if assigned f`q_expansion then
      g`q_expansion := f`q_expansion ;
   end if;
   if assigned f`weight then
      g`weight := f`weight;
   end if;
   if assigned f`which_conjugate then
      g`which_conjugate := f`which_conjugate;
   end if;
   if assigned f`eisenstein then
      g`eisenstein := f`eisenstein;
   end if;
   if assigned f`elliptic_curve then
      g`elliptic_curve := f`elliptic_curve;
   end if;
   if assigned f`q_expansion_gadget then
      g`q_expansion_gadget := f`q_expansion_gadget;
   end if;
   if assigned f`theta_data then
      g`theta_data := f`theta_data;
   end if;
   if assigned f`created_from then
      g`created_from := f`created_from;
   end if;
   if assigned f`modp_reductions then
      g`modp_reductions := f`modp_reductions;
   end if;
   if assigned f`padic_embeddings then
      g`padic_embeddings := f`padic_embeddings;
   end if;
   if assigned f`complex_embeddings then
      g`complex_embeddings := f`complex_embeddings;
   end if;
   return g;
end function;


